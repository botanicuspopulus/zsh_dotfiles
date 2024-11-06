#!/bin/zsh

[[ -d ${_Z_DATA:-$HOME/.z} ]] && {
  echo "ERROR: z.zsh's datafile (${_Z_DATA:-$HOME/.z}) is a directory."
}

function _common_matches() {
  local matches=$1
  local short

  for x in ${(@k)matches}
  do
    [[ -n ${matches[$x]} && ( -z $short ||  ${#x} < ${#short} ) ]] && short=$x
  done

  [[ $short == "/" ]] && return

  for x in ${(@k)matches}
  do
    [[ -n ${matches[$x]} && ${x:index($x, $short)} != 1 ]] && return
  done

  echo $short
}

function _output() {
  local matches=$1
  local best_match=$2
  local common=$3

  local list=()

  if [[ -n $list ]]
  then
    [[ -n $common ]] && list+=(printf "%10-s %s" "common:" "$common")

    for x in "${(@k)matches}"
    do
      [[ -n ${matches[$x]} ]] && list+=(printf "%-10s %s" "${matches[$x]}" "$x")
    done

    print -l ${(o)list[@]}
  else
    [[ -n $common && -z $method ]] && best_match=$common

    print $best_match
  fi
}

function _frecent() {
  local entry_time=$2
  local current_time=$(strftime "%s" "$EPOCHSECONDS")
  local rank=$1
  local dx=$(( current_time - entry_time ))
  local result=$(( 10000 * rank * ( 3.75 / ( ( 0.0001 * dx + 1 ) + 0.25 ) ) ))
  print $result
}

function _add_entry() {
  local path="$*"

  [[ $path = $HOME || $path = "/" ]] && return

  if (( ${#_Z_EXCLUDE_DIRS} > 0 ))
  then
    [[ " ${_Z_EXCLUDE_DIRS[@]} " =~ " ${path} " ]] && return
  fi

  zmodload zsh/datetime
  zmodload zsh/system

  local now=$(strftime "%s" "$EPOCHSECONDS")
  local -A rank time
  local count=0

  local lines=( ${(f)"$(< $datafile)"} )
  lines=( ${(M)lines:#/*\|[[:digit:]]##[.,]#[[:digit:]]#\|[[:digit:]]##} )

  rank[$path]=1
  time[$path]=$now

  for line in ${lines[@]}
  do
    local -a fields=( ${(s:|:)line} )
    local dir="${fields[1]}"
    local rank_val="${fields[2]}"
    local time_val="${fields[3]}"

    [[ ! -d $dir ]] && continue
    (( rank_val == 0 )) && continue

    if [[ $dir == $path ]]
    then
      rank[$dir]=$(( rank_val + 1 ))
      time[$dir]=$now
    else
      rank[$dir]=$rank_val
      time[$dir]=$time_val
    fi

    (( count += rank_val ))
  done

  local score=${_Z_MAX_SCORE:-9000}
  local content=""
  for dir in ${(k)rank}
  do
    local temp_rank=$(( (count > score ) ? ( rank[$dir] * 0.99 ) : rank[$dir] ))
    content+="$dir|$temp_rank|${time[$dir]}\n"
  done

  local tempfile=$(/usr/bin/mktemp)
  trap 'rm -f "$tempfile"' EXIT

  print "$content" >> "$tempfile"

  exit_status=$?

  if (( exit_status == 0 ))
  then
    [[ -n $_Z_OWNER ]] && chown "$_Z_OWNER:$(id -ng "$_Z_OWNER")" "$tempfile"
    /usr/bin/mv -f "$tempfile" "$datafile"
  fi
}

function _z () {
  local datafile="${_Z_DATA:-$HOME/.z}"

  [[ -L $datafile ]] &&  datafile=$(readlink "$datafile")

  if [[ -z $_Z_OWNER && -f $datafile && ! -O $datafile ]]
  then
    echo "ERROR: $_Z_DATA owner does not match the current user, consider unsetting _Z_OWNER" 
    return 1
  fi

  local add complete

  zparseopts -D -E -F -- \
    {a,-add}=add \
    {-complete}=complete \
    {c,-cwd}=restrict_to_cwd \
    {e,-best-match}=print_best_match \
    {h,-help}=print_help \
    {l,-list}=list_matches \
    {r,-highest-rank}=print_highest_rank \
    {t,-recent-access}=print_recent_access \
    {x,-remove-cwd}=remove_cwd || return

  (( $#restrict_to_cwd )) && fnd="$PWD "
  (( $#list_matches )) && lst=1
  (( $#print_highest_rank )) && method="rank"
  (( $#print_recent_access )) && method="recent"

  if (( $#help ))
  then
    print "${_Z_CMD:-z} [-cehlrtx] args"
    return 0
  fi

  if (( $#add ))
  then
    _add_entry "$@"
  elif (( $#complete && -s $datafile ))
  then
    local q="${2:2}"
    local imatch=0

    [[ $q == ${q:1} ]] && imatch=1
    q="${q// /.*}"

    local lines=( ${(f)"$(< $datafile)"} )
    for line in ${lines[@]}
    do
      local dir="${line%%|*}"

      if (( imatch != 0 ))
      then
        [[ "${dir:1}" =~ $q ]] && print "$dir"
      else 
        [[ "$dir" =~ $q ]] && print "$dir"
      fi
    done
  else
    local restrict_to_cwd list_matches print_best_match print_help print_highest_rank print_recent_access remove_cwd

    if (( $#remove_cwd ))
    then
      sed -i -e "\:^${PWD}|.*:d" "$datafile"
      return 0
    fi

    local fnd lst method

    local last="${@:-1}"

    [[ -n $fnd && $fnd != "$PWD " ]] || lst=1

    if [[ $last == /* && -d $last && -z $lst ]]
    then
      builtin cd "$last"
      return
    fi

    [[ -f $datafile ]] || return

    local cd
    local -A matches imatches
    local hi_rank=-99999999 ihi_rank=-99999999
    local best_match ibest_match
    
    local lines=( ${(f)"$(< $datafile)"} )

    for line in ${lines[@]}
    do
      local fields=( "${(s:|:)line}" )
      local dir="${fields[1]}"
      local rank="${fields[2]}"
      local time="${fields[3]}"

      case $method in
        rank) rank=$rank ;;
        recent) rank=$(( time - t )) ;;
        *) rank=$(_frecent $rank $time) ;;
      esac

      if [[ $dir =~ $fnd ]]
      then
        matches[$dir]=$rank
      elif [[ ${dir:1} =~ ${fnd:1} ]]
      then
        imatches[$dir]=$rank
      fi

      if [[ -n ${matches[$dir]} && ${matches[$dir]} -gt $hi_rank ]]
      then
        best_match=$dir
        hi_rank=${matches[$dir]}
      elif [[ -n ${imatches[$dir]} && ${imatches[$dir]} -gt $ihi_rank ]]
      then
        ibest_match=$dir
        ihi_rank=${imatches[$dir]}
      fi
    done

    if [[ -n $best_match ]]
    then
      cd=$(_output $matches $best_match $(_common_matches $matches))
    elif [[ -n $ibest_match ]]
    then
      cd=$(_output $imatches $ibest_match $(_common_matches $imatches))
    else
      return 1
    fi

    if [[ $cd ]]
    then
      if [[ $#print_best_match ]]
      then
        print "$cd"
      else
        builtin cd "$cd"
      fi
    fi
  fi
}

alias ${_Z_CMD:-z}='_z 2>&1'

[[ $_Z_NO_RESOLVE_SYMLINKS ]] || _Z_RESOLVE_SYMLINKS="-P"

if [[ -z $_Z_NO_PROMPT_COMMAND ]]
then
  if [[ $_Z_NO_RESOLVE_SYMLINKS ]]
  then
    function _z_precmd() {
      (_z --add "${PWD:a}" &)
      : $RANDOM
    }
  else
    function _z_precmd() {
      (_z --add "${PWD:A}" &)
      : $RANDOM
    }
  fi

  [[ -n ${precmd_functions[(r)_z_precmd]} ]] || precmd_functions[$(($#precmd_functions+1))]=_z_precmd
fi

function _z_zsh_tab_completion() {
  local compl
  read -l compl
  reply=( "$(_z --complete "$compl")" )
}
compctl -U -K _z_zsh_tab_completion _z
