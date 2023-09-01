#
# aliases - Zsh and bash aliases
#

# References
# - https://medium.com/@webprolific/getting-started-with-dotfiles-43c3602fd789#.vh7hhm6th
# - https://github.com/webpro/dotfiles/blob/master/system/.alias
# - https://github.com/mathiasbynens/dotfiles/blob/master/.aliases
# - https://github.com/ohmyzsh/ohmyzsh/blob/master/plugins/common-aliases/common-aliases.plugin.zsh
#

alias dirh='dirs -v'
if [[ -n "$ZSH_VERSION" ]]; then
  alias -- -='cd -'
  for index in {1..9}; do
    alias "$index"="cd +${index}"
    alias -g "..$index"=$(printf '../%.0s' {1..$index})
  done
  unset index
fi

if (( $+commands[bat] )); then
  tf() { tail -f "$1" | bat --paging=never -l log; }
fi

if (( $+commands[btm] )); then
  alias htop='btm'
fi

if (( $+commands[fd] )); then
  alias fdd='fd --type=directory'
  alias fde='fd --type=executable'
  alias fdf='fd --type=file'
  alias fds='fd --type=symlink'
fi

ranger() {
  pipx run --spec ranger-fm ranger
}

chmod_files() {
  fdf . -X chmod "$1" {}
}

chown_files() {
  fdf . -X chown "$1" {}
}

chown_dirs() {
  fdd . -X chown "$1" {}
}

# single character shortcuts - be sparing!
alias _=sudo

# mask built-ins with better defaults
alias ping='ping -c 5'
alias vi=vim
alias nv=nvim
alias grep="rg"

# directories
alias secrets="cd ${XDG_DATA_HOME:=~/.local/share}/secrets"

# fix typos
alias get=git
alias quit='exit'
alias cd..='cd ..'
alias zz='exit'

# tar
alias tarls="tar -tvf"
alias untar="tar -xf"

# date/time
alias timestamp="date '+%Y-%m-%d %H:%M:%S'"
alias datestamp="date '+%Y-%m-%d'"
alias isodate="date +%Y-%m-%dT%H:%M:%S%z"
alias utc="date -u +%Y-%m-%dT%H:%M:%SZ"
alias unixepoch="date +%s"

# disk usage
alias biggest='du -s ./* | sort -nr | awk '\''{print $2}'\'' | xargs du -sh'
alias dux='du -x --max-depth=1 | sort -n'
alias dud='du -d 1 -h'
alias duf='du -sh *'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias please=sudo
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias zbench='for i in {1..10}; do /usr/bin/time zsh -lic exit; done'
alias cls="clear && printf '\e[3J'"

# print things
alias print-fpath='for fp in $fpath; do echo $fp; done; unset fp'
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

# auto-orient images based on exif tags
alias autorotate="jhead -autorot"

# dotfiles
alias dotf='cd "$DOTFILES"'
alias dotfed='cd "$DOTFILES" && ${VISUAL:-${EDITOR:-vim}} .'
alias dotfl="cd \$DOTFILES/local"
alias zdot='cd $ZDOTDIR'

# java
alias setjavahome="export JAVA_HOME=\`/usr/libexec/java_home\`"

# todo-txt
alias t="todo.sh"
alias todos="$VISUAL $HOME/Desktop/todo.txt"

# Exa aliases
common_exa_flags='--icons --git'
additional_exa_flags='--time-style --color-scale'
alias ls='exa --icons'                                                    # ls
alias l='exa -lbF ${common_exa_flags}'                                    # list, size, type, git
alias ll='exa -lbGF ${common_exa_flags}'                                  # long list
alias llm='exa -lbGd ${common_exa_flags} --sort=modified'                 # long list, modified date sort
alias la='exa -lbhHigUmuSa ${common_exa_flags} ${additional_exa_flags}'   # all list
alias la='exa -lbhHigUmuSa@ ${common_exa_flags} ${additional_exa_flags}'  # all + extended list

alias lS='exa -1 --icons'
alias lt='exa --tree --level=2'

# noexpand
noexpand_aliases=(
  gpg
  grep
  ls
  vi
)

# vim: ft=zsh sw=2 ts=2 et
