#!/bin/zsh

if [[ -d ${_Z_DATA:-$HOME/.z} ]] 
then
  echo "ERROR: z.zsh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
fi

# Check if the user has fd installed
# If not, use find
if ! command -v fd &> /dev/null
then
  function fd() {
    find "$1" -name "$2" -type d
  }
fi

# Check if the user has fzf installed
# If not, spawn an error
if ! command -v fzf &> /dev/null
then
  echo "ERROR: z.zsh requires fzf to be installed."
  return 1
fi


if [[ -z $EPOCHSECONDS ]] 
then
  zmodload -i zsh/datetime
fi

local function _compute_match_score() {
  local -a query_components=( "${(s:/:)1}" )
  local -a entry_components=( "${(s:/:)2}" )

  local query_length=${#query_components}
  local entry_length=${#entry_components}

  local score=0

  local min_length=$(( query_length < entry_length ? query_length : entry_length ))

  for (( i = 1; i <= min_length; i++ ))
  do
    if [[ $query_components[i] == $entry_components[i] ]]
    then
      (( score++ ))
    else
      break
    fi
  done

  print $(( score * 10 ))
}

local function _update_score() {
  local entry_score=$1
  local entry_timestamp=$2
  local timestamp=$3

  print $(( entry_score-=(timestamp - entry_timestamp) / 86400 ))
}

local function _update_datafile() {
  local datafile="${_Z_DATA:-$HOME/.z}"
  local temp_file="${datafile}.tmp"

  print -l "${(On)@}" > "$temp_file"

  /usr/bin/mv "$temp_file" "$datafile"
}

local function _update_database() {
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")
  local datafile="${_Z_DATA:-$HOME/.z}"

  if [[ ! -f $datafile ]] 
  then
    print "1|$1|$timestamp" > "$datafile"
    return 0
  fi

  if [[ ! -s $datafile ]]
  then
    print "1|$1|$timestamp" >> "$datafile"
    return 0
  fi

  local found=0
  local query="$1"
  local -a new_lines
  for line in "${(f)"$(<$datafile)"}"
  do
    # Check that the line is in the correct format
    [[ $line == (#b)([0-9]##)\|(*[^|])\|([0-9]##) ]] || continue

    local fields=( "${(s:|:)line}" )

    local entry_path="${fields[2]}"

    [[ ! -d $entry_path ]] && continue

    local entry_timestamp=${fields[3]}
    local entry_score=$(_update_score ${fields[1]} $entry_timestamp $timestamp)

    if [[ $entry_path == $query ]]
    then
      found=1
      entry_score=$(( entry_score < 0 ? 0 : entry_score ))
      (( entry_score+=1 ))
      entry_timestamp=$timestamp
    fi

    (( entry_score < 1 )) && continue

    new_lines+=( "$entry_score|$entry_path|$entry_timestamp" )
  done

  if (( ! found ))
  then
    new_lines+=( "1|$query|$timestamp" )
  fi

  _update_datafile "${(@)new_lines}"

  return 0
}

local function _search_database() {
  local datafile="${_Z_DATA:-$HOME/.z}"
  [[ -s $datafile ]] || return

  local query="$1"
  local -a matches
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")

  local -a new_lines
  for line in "${(f)"$(<$datafile)"}"
  do
    [[ $line == (#b)([0-9]##)\|(*[^|])\|([0-9]##) ]] || continue

    local fields=( "${(s:|:)line}" )
    local entry_path="${fields[2]}"

    [[ ! -d $entry_path ]] && continue

    if [[ $entry_path == $query ]]
    then
      print -r -- "$entry_path"
      return 0
    fi

    if [[ $entry_path == *$query* ]]
    then
      local entry_score=$(_update_score ${fields[1]} ${fields[3]} $timestamp)
      local match_score=$(_compute_match_score "$query" "$entry_path")
      local score=$(( entry_score + match_score ))

      matches+=( "$score|$entry_path" )
    fi
  done

  if (( ${#matches} > 0 ))
  then
    print -r -- "${${(@On)matches}[1]#*|}"
  fi

  return 0
}

local function _remove_entry() {
  local datafile="${_Z_DATA:-$HOME/.z}"
  [[ -s $datafile ]] || return 0

  local timestamp=$(strftime "%s" "$EPOCHSECONDS")
  local query="$1"
  local -a new_lines
  for line in "${(f)"$(<$datafile)"}"
  do
    [[ $line == (#b)([0-9]##)\|(*[^|])\|([0-9]##) ]] || continue

    local fields=( "${(s:|:)line}" )
    local entry_path="${fields[2]}"

    [[ ! -d $entry_path ]] && continue
    [[ $entry_path == $query ]] && continue

    local entry_timestamp=${fields[3]}
    local entry_score=$(_update_score ${fields[1]} $entry_timestamp $timestamp)

    new_lines+=( "$entry_score|$entry_path|$entry_timestamp" )
  done

  _update_datafile "${(@)new_lines}"

  return 0
}

local function _change_directory() {
  local output
  zparseopts -D -F -K --\
    {o,-output}=output || return 1

  local cmd="cd"
  if (( ${#output} ))
  then
    cmd="print -r --"
  fi

  if [[ -z $@ ]] 
  then
    eval "$cmd ${HOME}" 
    return 0
  fi

  if [[ $1 == $HOME || $1 == ~ || $1 == - || $1 == / ]]
  then
    eval "$cmd $1"
    return 0
  fi

  local query="${1/#\~/$HOME}"
  if [[ -d $query ]]
  then
    query="${PWD}/${query}"
    eval "$cmd $query"
    return $(_update_database "${query}")
  fi

  if (( ${#use_cwd} ))
  then
    base_path="$PWD"
  else
    base_path="/"
  fi

  local match=$(_search_database "$query")
  if [[ -n $match ]]
  then
    eval "$cmd $match"
    return $(_update_database "${match}")
  else
    local base_dir

    cd_path=$(fd "$base_path" --type=directory --full-path "$base_path" | fzf --no-multi --query="$query")
    eval "$cmd $cd_path"
    return $(_update_database "${cd_path}")
  fi

  print "z: no such path: $query" >&2
  return 1
}

local function _print_help(){
  cat <<EOF
Usage: z [options] [directory]

Options:
  -a, --add DIRECTORY    Add DIRECTORY to the database
  -c, --complete         Print the list of directories in the database
  -r, --remove           Remove the directory from the database
  -p, --cwd              Use the current working directory as the base path
  -h, --help             Print this help message
  -o, --output           Output the directory to stdout instead of changing to it

If no arguments are given, z will change to the home directory.
EOF
}

local function _complete() {
  local query="${1}"

  local -a matches
  local datafile="${_Z_DATA:-$HOME/.z}"
  [[ -s $datafile ]] || return 1

  for line in "${(f)"$(<$datafile)"}"
  do
    [[ $line == (#b)([0-9]##)\|(*[^|])\|([0-9]##) ]] || continue

    local fields=( "${(s:|:)line}" )
    local entry_path="${fields[2]}"

    [[ ! -d $entry_path ]] && continue

    if [[ $entry_path == *$query* ]]
    then
      matches+=( "$entry_path" )
    fi
  done

  local -a directories=( "${(@f)"$(fd . --type=directory --max-depth=1)"}" )

  compadd -x '%U%BDatabase%b%u' -J 'database' -a matches
  compadd -x '%U%BCurrent Directory%b%u' -J 'current_directory' -a directories
}

compdef _complete ${_Z_CMD:-z}

local function _z () {
  local add complete remove use_cwd help output

  zparseopts -D -F -K --\
    {a,-add}:=add \
    {c,-complete}:=complete \
    {r,-remove}:=remove \
    {p,-cwd}=use_cwd \
    {o,-output}=output \
    {h,-help}=help || return 1

  if (( ${#help} ))
  then
    _print_help
    return 0
  elif (( ${#complete} ))
  then
    _complete "${complete[-1]}"
    return 0
  elif (( ${#remove} ))
  then
    return $(_remove_entry "${remove[-1]}")
  elif (( ${#add} ))
  then
    return $(_update_database "${add[-1]}")
  else
    _change_directory ${output} "${@}"
    return 0
  fi
}

alias ${_Z_CMD:-z}='_z 2>&1'
