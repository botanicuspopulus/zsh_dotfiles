#!/bin/zsh

if [[ -d ${_Z_DATA:-$HOME/.z} ]] 
then
  echo "ERROR: z.zsh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
fi

# If not, use find
if ! command -v fd &> /dev/null
then
  function fd() {
    find "$1" -name "$2" -type d
  }
fi

if ! command -v fzf &> /dev/null
then
  echo "ERROR: z.zsh requires fzf to be installed."
  return 1
fi

if [[ -z $EPOCHSECONDS ]] 
then
  zmodload -i zsh/datetime
fi

typeset -A _z_entries

local function _load_entries() {
  local datafile="${_Z_DATA:-$HOME/.z}"

  if [[ ! -f $datafile ]]
  then
    touch $datafile
    return 0
  fi

  for line in "${(f)"$(<$datafile)"}"
  do
    [[ $line = (#b)([0-9]##)\|([0-9]##)\|(*) ]] || continue

    local fields=( "${(s:|:)line}" )

    [[ ! -d ${fields[3]} ]] && continue

    _z_entries[${fields[3]}]="${fields[1]}|${fields[2]}"
  done

  return 0
}

local function _save_entries() {
  local datafile="${_Z_DATA:-$HOME/.z}"
  : >! "$datafile"

  if [[ $? -ne 0 ]]
  then
    print "z: error writing to $datafile" >&2
    return 1
  fi

  local timestamp=$(strftime "%s" "$EPOCHSECONDS")
  for entry in "${(@k)_z_entries}"
  do
    local fields=( "${(s:|:)_z_entries[$entry]}" )
    local entry_timestamp=${fields[2]}
    local entry_score=$(( fields[1] - (timestamp - entry_timestamp) / ${_Z_AGE_RATE:-604800} ))

    if (( entry_score < 0 ))
    then
      unset _z_entries[$entry]
      continue
    fi

    print -r -- "${entry_score}|${entry_timestamp}|${entry//\"/}" >> "$datafile"
  done
}

local function _compute_match_score() {
  local -a query_components=( "${(s:/:)1}" )
  local -a entry_components=( "${(s:/:)2}" )

  local query_length=${#query_components}
  local entry_length=${#entry_components}

  local score=0

  local min_length=$(( query_length < entry_length ? query_length : entry_length ))

  for (( i = 1; i <= min_length; i++ ))
  do
    if [[ $query_components[-i] == $entry_components[-i] ]]
    then
      (( score += i ))
    else
      break
    fi
  done

  print $(( score * 10 ))
}

local function _update_database() {
  local query="$1"
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")

  _load_entries

  if [[ -n ${_z_entries[$query]} ]]
  then
    local fields=( "${(s:|:)_z_entries[$query]}" )
    local entry_score=$(( fields[1] + 1 ))
    _z_entries[$query]="${entry_score}|${timestamp}"
  else
    _z_entries[$query]="1|${timestamp}"
  fi

  _save_entries
}

local function _search_database() {
  local query="$1"
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")

  _load_entries

  local -a matches
  for entry in "${(@k)_z_entries}"
  do
    if [[ $entry == *$query* ]]
    then
      local fields=( "${(s:|:)_z_entries[$entry]}" )
      local match_score=$(_compute_match_score "$query" "$entry")
      local score=$(( ${fields[1]} + match_score ))
      matches+=( "$score|$entry" )
    fi
  done

  [[ -z ${matches} ]] && return

  local best_match=""
  for match in "${(@On)matches}"
  do
    best_match="${match#*|}"

    if [[ $best_match != *$query ]] && best_match="${best_match%%$query*}$query"

    [[ $best_match != ${PWD} ]] && break
  done

  print -r -- "${best_match//\"/}"
}

local function _remove_entry() {
  _load_entries
  unset _z_entries["$1"]
  _save_entries
}

local function _change_directory() {
  if [[ -z $@ ]] 
  then
    cd "${HOME}" 
    return
  fi

  if [[ $1 == $HOME || $1 == ~ || $1 == - || $1 == / ]]
  then
    cd "$1"
    return
  fi

  local query="${1/#\~/$HOME}"
  if [[ -d $query ]]
  then
    cd "${query}"
    _update_database "${PWD}"
    return
  fi

  local match=$(_search_database "$query")
  if [[ -n $match ]]
  then
    cd "${match}"
    _update_database "${PWD}"
    return
  fi

  local cd_path=$(fd "$query" "/" --type=directory --max-results 100 \
                  | fzf --no-multi \
                        --query "$query" \
                        --height=40% \
                        --layout=reverse \
                        --scheme=path \
                        --exact \
                        --preview 'eza --only-dirs --tree --level=3 --icons {}')
  [[ $cd_path == "" ]] && return 1

  cd "${cd_path}"
  _update_database "${PWD}"
  return
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

local function _z_complete() {
  local query="${1}"

  _load_entries

  local -a matches
  for path in "${(@k)_z_entries}"
  do
    [[ $path == *$query* ]] && matches+=( "$path" )
  done

  [[ -z ${matches} ]] && return

  local selected=$(print -l -- "${(@)matches}" \
                    | fzf --no-multi --query "$query" \
                          --height=40% \
                          --layout=reverse \
                          --exact \
                          --preview 'eza --only-dirs --tree --level=3 --icons {}')

  [[ -z ${selected} ]] && return
  print -r -- "${selected}"
}

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
  elif (( ${#complete} ))
  then
    _z_complete "${complete[-1]}"
  elif (( ${#remove} ))
  then
    _remove_entry "${remove[-1]}"
  elif (( ${#add} ))
  then
    _update_database "${add[-1]}"
  else
    _change_directory ${use_cwd} ${output} "${@}"
  fi
}

alias ${_Z_CMD:-z}='_z 2>&1'
