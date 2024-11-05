#!/usr/bin/env zsh

# fzf
# fzf-powered CTRL-R
# Ctrl-T: setting ripgrep or fd as the default source for ctrl-T fzf
if (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --hidden --follow --no-messages --glob "!.git/" .'
elif (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f .'
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag --path-to-ignore ~/.ignore --hidden --nogroup -l .'
else
  export FZF_DEFAULT_COMMAND='find -L . -mindepth 1 .'
fi

if [[ -f /usr/share/fzf/completion.zsh ]]; then
  source /usr/share/fzf/completion.zsh
elif [[ -f $DOTFILES/fzf/shell/completion.zsh ]]; then
  source $DOTFILES/fzf/shell/completion.zsh
fi

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --pointer ' ' \
  --marker '󰁔 ' \
  --prompt ':: ' \
  --layout=reverse \
  --border=rounded \
  --color=bg+:black \
  --color=bg:-1 \
  --color=border:cyan \
  --color=fg:white \
  --color=gutter:-1 \
  --color=header:yellow \
  --color=hl+:cyan \
  --color=hl:cyan \
  --color=info:gray \
  --color=marker:magenta \
  --color=pointer:magenta \
  --color=prompt:cyan \
  --color=query:white:regular \
  --color=scrollbar:cyan \
  --color=separator:yellow \
  --color=spinner:magenta \
"
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --hidden --follow --type d"

export FZF_ALT_C_OPTS="--preview='eza --tree --color always --icons --level=2 --only-dirs {} | head -n 50'"

export FZF_COMPLETION_OPTS='--border --info=inline'

function _fzf_select_and_exit() {
  fzf --select-1 --exit-0 --query="$*"
}

function _fd () {
  # Check if $1 is /, if so, use --full-path, otherwise just use fd
  if [[ $1 == "/" ]]; then
    fd $1 --full-path ${@}
  else
    fd $@
  fi
}

function _fdtype () {
  _fd $1 --type $2 ${@:3}
}

function fdr () {
  _fd / $@
} 

function _fdhtype () {
  _fdtype $1 $2 --hidden --no-ignore ${@:3}
}

function fdd () {
  _fdtype $1 directory ${@:2}
}

function fde () {
  _fdtype $1 executable ${@:2}
}

function fdf () {
  _fdtype $1 file ${@:2}
}

function fds () {
  _fdtype $1 symlink ${@:2}
}

function fdh () {
  _fd $1 --hidden --no-ignore ${@:2} 
}

function fddh () {
  _fdhtype $1 directory ${@:2}
}

function fdeh () {
  _fdhtype $1 executable ${@:2}
}

function fdfh () {
  _fdhtype $1 file ${@:2}
}

function fdsh () {
  _fdhtype $1 symlink ${@:2}
}

function show() {
  local file=$(fdr | _fzf_select_and_exit "$*")
  [[ ! -n $file ]] && echo "no results found" && return 1
  [[ -f $file ]] && bat "$file"
  [[ -d $file ]] && cd "$file"
}

function showl() {
  local file=$(_fzf_select_and_exit "$*")
  [[ ! -n $file ]] && echo "no results found" && return 1
  [[ -f $file ]] && bat "$file"
  [[ -d $file ]] && cd "$file"
}

# global file search -> vim
function vf() {
  local file=$(fdr | _fzf_select_and_exit "$*")
  [[ -f $file ]] && "${EDITOR:-nvim}" "$file"
  [[ -d $file ]] && cd "$file"
}

function fa() {
  local dir=$(fdd . | fzf --no-multi --query="$*") && cd "$dir"
}

function fah() {
  local dir=$(fddh . | fzf --no-multi --query="$*") && cd "$dir"
}

# global: cd into the directory of the selected file
# similar to 'zz', but this one does a full global file search
function fl() {
  local file=$(fdr | fzf +m -q "$*") && cd "${file:h}"
  eza --oneline --icons
}

function fenv() {
  env | fzf
}

function _rg () {
  rg --no-messages "$*"
}

function _fzf_select_preview() {
  local args="$*"
  if (( ${#args} == 0 ))
  then
    [ -p /dev/stdin ] && args="$(</dev/stdin)" || exit 1
  fi

  local margin=5
  local preview_cmd='search={};
    search=( ${(s/:/)search} );
    file=${search[1]};
    line=${search[2]};'
  preview_cmd+="margin=5;" 
  preview_cmd+='tail -n +$(( (line - margin) > 0 ? (line - margin) : 0)) $file \
    | head -n $(( margin*2 + 1 )) \
    | bat --paging=never --color=always --style=full --file-name $file --highlight-line $(( margin + 1))'
  
  echo "$args" | fzf --disabled --select-1 --exit-0 --preview-window up:$((2*margin + 1)) --preview="$preview_cmd"
}

# search source code, then pipe files with 10 lines file buffer into fzf preview using bat
# requirements:
# - fzf: https://github.com/junegunn/fzf
# - bat: https://github.com/sharkdp/bat
# - rg: https://gtihub.com/dandavison/rg
# - fd: https://github.com/sharkdp/fd
function s() {
  local full=$(_rg "$*" | _fzf_select_preview)

  full=( ${(s/:/)full} )
  local file="${full[1]}"
  local line="${full[2]}"
}
