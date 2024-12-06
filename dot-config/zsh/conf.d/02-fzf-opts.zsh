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

FZF_COLORS="bg+:#283457,\
bg:#16161e,\
border:#27a1b9,\
fg:#c0caf5,\
gutter:#16161e,\
header:#ff9e64,\
hl+:#2ac3de,\
hl:#2ac3de,\
info:#545c7e,\
marker:#ff007c,\
pointer:#ff007c,\
prompt:#2ac3de,\
query:#c0caf5:regular,\
scrollbar:#27a1b9,\
separator:#ff9e64,\
spinner:#ff007c"

export FZF_TMUX_OPTS="-p"

export FZF_DEFAULT_OPTS="$FZF_DEFAULT_OPTS \
  --highlight-line \
  --info=inline-right \
  --pointer ' ' \
  --marker '󰁔 ' \
  --prompt ':: ' \
  --layout=reverse \
  --border=rounded \
  --color '${FZF_COLORS}'"

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --hidden --follow --type directory"
export FZF_ALT_C_OPTS="--preview='eza --tree --color always --icons --level=2 --only-dirs {} | head -n 50'"
export FZF_COMPLETION_OPTS='--border --info=inline'
export FZF_COMPLETION_DIR_COMMANDS="cd pushd rmdir tree ls"

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

function _fdtype () { _fd $1 --type $2 ${@:3} }
function _fdhtype () { _fdtype $1 $2 --hidden --no-ignore ${@:3} }
function _rg () { rg --no-messages --column --line-number "$*" }

function fdr () { _fd / $@ } 
function fdd () { _fdtype $1 directory ${@:2} }
function fde () { _fdtype $1 executable ${@:2} }
function fdf () { _fdtype $1 file ${@:2} }
function fds () { _fdtype $1 symlink ${@:2} }
function fdh () { _fd $1 --hidden --no-ignore ${@:2} }
function fddh () { _fdhtype $1 directory ${@:2} }
function fdeh () { _fdhtype $1 executable ${@:2} }
function fdfh () { _fdhtype $1 file ${@:2} }
function fdsh () { _fdhtype $1 symlink ${@:2} }
function fa() { local dir=$(fdd . | fzf --no-multi --query="$*") && cd "$dir" }
function fah() { local dir=$(fddh . | fzf --no-multi --query="$*") && cd "$dir" }
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
# similar to 'zz', but this one does a full global file search
function fl() {
  local file=$(fdr | fzf +m -q "$*") && cd "${file:h}"
  eza --icons
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
    line=${search[2]};
    margin='${margin}'; 
    tail -n +$(( (line - margin) > 0 ? (line - margin) : 0)) $file \
    | head -n $(( margin*2 + 1 )) \
    | bat --paging=never --color=always --style=numbers,snip --file-name $file --highlight-line {2} {1}'

  echo "$args" | \
    fzf --select-1 
        --exit-0 \
        --delimiter=':' \
        --preview-window up:$((2*margin + 1)) \
        --preview="$preview_cmd"
}

# search source code, then pipe files with 10 lines file buffer into fzf preview using bat
# requirements:
# - fzf: https://github.com/junegunn/fzf
# - bat: https://github.com/sharkdp/bat
# - rg: https://gtihub.com/dandavison/rg
# - fd: https://github.com/sharkdp/fd
function s() {
  local RELOAD='reload:rg --column --line-number --smart-case {q} || :'
  local OPENER='if (( FZF_SELECT_COUNT == 0 )); then
                  nvim  {1} +{2}
                else
                  nvim +cw -q {+f} # Build quickfix list for selected items
                fi'
  local HEADER_LINES=4
  local OFFSET=3
  local TERMINAL_WIDTH=80
  fzf --disabled --ansi \
      --bind "start:$RELOAD" \
      --bind "change:$RELOAD" \
      --bind "enter:become:$OPENER" \
      --bind "ctrl-o:execute:$OPENER" \
      --delimiter ':' \
      --preview "bat --style=full --color=always --highlight-line {2} {1}" \
      --preview-window "~${HEADER_LINES},+{2}+${HEADER_LINES}/${OFFSET},<${TERMINAL_WIDTH}(up)" \
      --query "$*"
}

function fif() {
  if (( $# == 0 )); then
    echo "Usage: fif <query>"
    return 1
  fi

  rg --files-with-matches --no-messages "$1" \
    | fzf --preview "highlight -O ansi -l {} 2> /dev/null \
    | rg --colors 'match:bg:yellow' --ignore-case --pretty --context 10 '$1' \
    || rg --ignore-case --pretty --context 10 '$1' {}"
}

function fifa() {
  if (( $# == 0 )); then
    echo "Usage: fifa <query>"
    return 1
  fi

  local file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" \
    | fzf-tmux -p +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" \
    && print -z "./$file" || return 1
}

function fpdf() {
  result=$(fdf --glob '*.pdf' | fzf --bind "ctrl-r:reload(fdf '*.pdf')" --preview "pdftotext {} - | less")
  [[ -n $result ]] && nohup zathura "$result" &>/dev/null & disown
}

function fman() {
  man -k . | fzf --query="$1" --prompt='man>' --preview  $'echo {} | tr -d \'()\' | awk \'{printf "%s ", $2} {print $1}\' | xargs -r man' | tr -d '()' | awk '{printf "%s ", $2} {print $1}' | xargs -r man
}

function fyay() {
  yay -Slq | fzf --multi --reverse --preview 'yay -Si {1}' | xargs -ro yay -S
}
