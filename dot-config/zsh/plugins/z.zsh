#!/bin/zsh
#
# This script provides a directory jumping tool similar to `z` or `zoxide`.
# It maintains a database of directories and their usage frequency, allowing
# quick navigation to frequently visited directories.

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

# Load the `zsh/datetime` module if `EPOCHSECONDS` is not available.
if [[ -z $EPOCHSECONDS ]] 
then
  zmodload -i zsh/datetime
fi

# Declare an associative array to store directory entries.
typeset -A _z_entries

# Function to load entries from the datafile into the associative array.
local function _load_entries() {
  local datafile=""

  [[ ! -f ${_Z_DATA:-$HOME/.z} ]] && touch ${_Z_DATA:-$HOME/.z}

  for line in "${(f)$(<${_Z_DATA:-$HOME/.z})}"; do
    local fields=( "${(s:|:)line}" )
    _z_entries[$fields[3]]="$fields[1]|$fields[2]"
  done
}

# Function to save entries from the associative array to the datafile.
local function _save_entries() {
  : >! "${_Z_DATA:-$HOME/.z}" || {
    print "z: error clearing ${_Z_DATA:-$HOME/.z}" >&2
    return 1
  }

  local timestamp=$(strftime "%s" "$EPOCHSECONDS")
  for entry in "${(@k)_z_entries}"
  do
    local fields=( "${(s:|:)_z_entries[$entry]}" )
    local entry_score=$(( fields[1] - (timestamp - fields[2]) / ${_Z_AGE_RATE:-604800} ))

    (( entry_score < 0 )) && unset _z_entries[$entry] && continue

    print -r -- "${entry_score}|${fields[2]}|${entry//\"/}" >> "${_Z_DATA:-$HOME/.z}"
  done
}

# Function to compute the match score for a given query and entry.
local function _compute_match_score() {
  local query="$1"
  local entry="$2"
  local -a entry_components=( "${(s:/:)entry}" )

  local score=0

  [[ -n $entry_components[(r)$query] ]] && (( score += 10 ))

  local fields=( "${(s:|:)_z_entries[$entry]}" )
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")
  local age=$(( (timestamp - fields[2]) / ${_Z_AGE_RATE:-604800} ))

  (( score += fields[1] * 2 - age))

  print $score
}

# Function to update the database with a new or existing entry.
local function _update_database() {
  local query="$1"
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")

  _load_entries

  if [[ -n ${_z_entries[$query]} ]]
  then
    local fields=( "${(s:|:)_z_entries[$query]}" )
    _z_entries[$query]="$(( fields[1] + 1 ))|$timestamp"
  else
    _z_entries[$query]="1|$timestamp"
  fi

  _save_entries
}

# Function to search the database for a matching entry.
local function _search_database() {
  local timestamp=$(strftime "%s" "$EPOCHSECONDS")

  _load_entries

  local -a query_components=( "${(s: :)1}" )
  local -A matches

  for query in $query_components; do
    for match in "${(@Mk)_z_entries:#*$q*}"; do
      (( matches[$match]+=$(_compute_match_score "$query" "$match") ))
    done
  done

  [[ -z ${matches} ]] && return

  local sorted_matches=( "${(@On)${(@k)matches/(#m)*/$matches[$MATCH]|$MATCH}}" )
  local best_match
  local component="${query_components[-1]}"
  for match in "${sorted_matches}"; do
    best_match="${match#*|}"

    [[ $best_match != *$component ]] && {
      best_match="${best_match%%$component*}$component"
    }

    [[ $best_match != ${PWD} ]] && break
  done

  print -r -- "${best_match//\"/}"
}

# Function to remove an entry from the database.
local function _remove_entry() {
  _load_entries
  unset _z_entries[$1]
  _save_entries
}

# Function to change the current directory based on the query.
local function _change_directory() {
  [[ -z $@ ]] && cd "${HOME}" && return

  local query="${1/#\~/$HOME}"
  local skip_values=( "$HOME" "-" "/" )

  (( ${#skip_values[(r)$query]} > 0 )) && cd "$query" && return 

  if [[ -d $query ]]; then
    cd "${query}"
    _update_database "${PWD}"
    return
  fi

  local match=$(_search_database "$query")
  if [[ -n $match ]]; then
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

  local -a matches=( ${(Mk)_z_entries:#*$query*} )
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
