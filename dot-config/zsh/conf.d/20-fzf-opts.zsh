#!/usr/bin/env zsh

# fzf
# fzf-powered CTRL-R
# Ctrl-T: setting ripgrep or fd as the default source for ctrl-T fzf
if (( $+commands[fd] )); then
  export FZF_DEFAULT_COMMAND='fd --hidden --follow --type f --strip-cwd-prefix'
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-messages --glob "!.git/"'
elif (( $+commands[ag] )); then
  export FZF_DEFAULT_COMMAND='ag --path-to-ignore ~/.ignore --hidden --nogroup -l .'
else
  export FZF_DEFAULT_COMMAND='find -L . -mindepth 1'
fi

export FZF_TMUX_OPTS="-p 85%,75%"

export FZF_DEFAULT_OPTS="\
  --info=inline-right \
  --layout=reverse \
  --border=rounded \
  --bind 'ctrl-/:toggle-preview' \
  ${FZF_STYLE} \
  --color '${FZF_COLORS}'"

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --hidden --follow --type directory --strip-cwd-prefix"
export FZF_CTRL_T_OPTS="--preview 'fzf-preview {}'"
export FZF_ALT_C_OPTS="--preview 'eza \$EZA_COMMON --tree --git-ignore --color=always --icons=always --level=2 --only-dirs {}'"

function _fzf_select_and_exit() {
  fzf --select-1 --exit-0 --query="$*"
}

function __fd () {
  # If $1 is /, search the whole filesystem (skipping pseudo-filesystems), otherwise just use fd
  if [[ $1 == "/" ]]; then
    fd --full-path --exclude /proc --exclude /sys --exclude /dev --exclude /run "${@:2}" /
  else
    fd "$@"
  fi
}

# $1 = type, rest passed to fd (pattern optional)
function _fdtype () { fd --type "$1" "${@:2}" }
function _fdhtype () { _fdtype "$1" --hidden --no-ignore "${@:2}" }

function fdr () { __fd / "$@" }
function fdd () { _fdtype directory "$@" }
function fde () { _fdtype executable "$@" }
function fdf () { _fdtype file "$@" }
function fds () { _fdtype symlink "$@" }
function fdh () { fd --hidden --no-ignore "$@" }
function fddh () { _fdhtype directory "$@" }
function fdeh () { _fdhtype executable "$@" }
function fdfh () { _fdhtype file "$@" }
function fdsh () { _fdhtype symlink "$@" }
function fa() { local dir=$(fd --type d --strip-cwd-prefix | fzf --no-multi --query="$*") && cd "$dir" }
function fah() { local dir=$(fd --type d --hidden --no-ignore --strip-cwd-prefix | fzf --no-multi --query="$*") && cd "$dir" }
function fenv() { env | fzf }

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

# global: cd into the directory of the selected file
function fl() {
  local file=$(fdr | fzf +m -q "$*") && cd "${file:h}"
  eza ${=EZA_COMMON} --icons=auto
}

# search source code, then pipe files with 10 lines file buffer into fzf preview using bat
# requirements:
# - fzf: https://github.com/junegunn/fzf
# - bat: https://github.com/sharkdp/bat
# - rg: https://gtihub.com/dandavison/rg
# - fd: https://github.com/sharkdp/fd
function s() {
  local RELOAD='reload:rg --color=always --column --line-number --smart-case {q} || :'
  local OPENER='if (( FZF_SELECT_COUNT == 0 )); then
                  ${EDITOR:-nvim} {1} +{2}
                else
                  ${EDITOR:-nvim} +cw -q {+f} # Build quickfix list for selected items
                fi'
  local HEADER_LINES=1
  local OFFSET=3
  local TERMINAL_WIDTH=80
  fzf --disabled --ansi \
      --bind "start:$RELOAD" \
      --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --delimiter ':' \
      --preview "bat --style=numbers,header --color=always --highlight-line {2} {1}" \
      --preview-window "~${HEADER_LINES},+{2}+${HEADER_LINES}/${OFFSET},<${TERMINAL_WIDTH}(up)" \
      --query "$*"
}

function fif() {
  if (( $# == 0 )); then
    echo "Usage: fif <query>"
    return 1
  fi

  Q=$1 rg --files-with-matches --no-messages -- "$1" \
    | Q=$1 fzf --preview 'rg --pretty --ignore-case --context 10 -- "$Q" {}'
}

function fifa() {
  if (( $# == 0 )); then
    echo "Usage: fifa <query>"
    return 1
  fi

  local file="$(Q="$*" rga --max-count=1 --ignore-case --files-with-matches --no-messages -- "$*" \
    | Q="$*" fzf-tmux -p +m --preview='rga --ignore-case --pretty --context 10 -- "$Q" {}')" \
    && print -z "./$file" || return 1
}

function fpdf() {
  local opener=zathura
  (( $+commands[zathura] )) || opener=xdg-open
  local result=$(fdf -e pdf | fzf --bind "ctrl-r:reload(fd --type file -e pdf)" --preview 'fzf-preview {}')
  [[ -n $result ]] && nohup "$opener" "$result" &>/dev/null & disown
}

function fman() {
  command -v man &>/dev/null || { echo "man not installed" ; return 1; }
  man -k . | fzf --query="$1" --prompt='man> ' \
    --preview 'MANWIDTH=$FZF_PREVIEW_COLUMNS man {1} 2>/dev/null' \
    | awk '{print $1}' | xargs -r man
}

function fyay() {
  command -v yay &>/dev/null || { echo "yay not installed" ; return 1; }
  yay -Slq | fzf --multi --reverse --preview 'yay -Si {1}' | xargs -ro yay -S
}
