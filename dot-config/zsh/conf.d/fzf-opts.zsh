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

source $XDG_CONFIG_HOME/zsh/themes/tokyonight_night.sh

export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND="fd --hidden --follow --type d"

export FZF_ALT_C_OPTS="--preview='eza --tree --color always --icons --level=2 --only-dirs {} | head -n 50'"

export FZF_COMPLETION_OPTS='--border --info=inline'

function show() {
  local file
  file=$(fd / | fzf --query="$*" --select-1 --exit-0)
  [ ! -n "$file" ] && echo "no results found" && return -1
  [ -f "$file" ] && bat "$file"
  [ -d "$file" ] && cd "$file"
}

function showl() {
  local file
  file=$(fzf --query="$*" --select-1 --exit-0)
  [ ! -n "$file" ] && echo "no results found" && return -1
  [ -f "$file" ] && bat "$file"
  [ -d "$file" ] && cd "$file"
}

# global file search -> vim
function vf() {
  local file
  file="$(fd / | fzf --query="$*" --select-1 --exit-0)"
  [ -f "$file" ] && nvim "$file"
  [ -d "$file" ] && echo "Result is a directory, running cd" && cd "$file"
}

fa() {
  local dir
  dir=$(fd --type directory | fzf --no-multi --query="$*") && cd "$dir"
}

fah() {
  local dir
  dir=$(fd --type directory --hidden --no-ignore | fzf --no-multi --query="$*") && cd "$dir"
}

# global: cd into the directory of the selected file
# similar to 'zz', but this one does a full global file search
fl() {
  local file
  local dir
  file=$(fd / | fzf +m -q "$*") && dir=$(dirname "$file") && cd "$dir"
  ls
}

fenv() {
  local out
  out=$(env | fzf)
  echo $(echo $out)
}

# search source code, then pipe files with 10 lines file buffer into fzf preview using bat
# requirements:
# - fzf: https://github.com/junegunn/fzf
# - bat: https://github.com/sharkdp/bat
# - rg: https://gtihub.com/dandavison/rg
# - fd: https://github.com/sharkdp/fd
s() {
  local margin=5 # number of lines above and below search result
  local preview_cmd='search={};file=$(echo $search | | cut -d':' -f 1);'
  preview_cmd+="margin=$margin;" # Inject value into space
  preview_cmd+='line=$(echo $search | cut -d':' -f 2);'
  preview_cmd+='tail -n +$(( $(( $line - $margin )) > 0 ? $(($line - $margin)) : 0)) $file | head -n $(( $margin*2 + 1 )) |'
  preview_cmd+='bat --paging=never --color=always --style=full --file-name $file --highlight-line $(( $margin + 1))'
  local=$(rg "$*" \
    | fzf --select-1 --exit-0 --preview-window up:$(( $margin*2 + 1 )) --height=60% --preview $preview_cmd)
      local file="$(echo $full | awk -F: '{print $1}')"
      local line="$(echo $full | awk -F: '{print $2}')"
      [ -n "$file" ] && nvim "$file" +$line
}
