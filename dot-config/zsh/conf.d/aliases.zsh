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
  chmod_files() {
    fdf . -X chmod "$1" {}
  }

  chown_files() {
    fdf . -X chown "$1" {}
  }

  chown_dirs() {
    fdd . -X chown "$1" {}
  }
fi

alias -s {c,h,cpp,py,sh,md,txt,conf,ini,yml,yaml,toml,xml,html,css,js,json,sql}=nvim
alias -s {pdf,djvu}=zathura

# mask built-ins with better defaults
alias ping='ping -c 5'
alias cat=bat

# directories
alias secrets="cd ${XDG_DATA_HOME:=~/.local/share}/secrets"

# fix typos
alias get=git
alias quit='exit'
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

alias bathelp='bat --plain --language=help'
help() {
  "$@" --help 2>&1 | bathelp
}

alias -g -- -h='-h 2>&1 | bathelp'
alias -g -- --help='--help 2>&1 | bathelp'

# url encode/decode
alias urldecode='python3 -c "import sys, urllib.parse as ul; \
    print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python3 -c "import sys, urllib.parse as ul; \
    print (ul.quote_plus(sys.argv[1]))"'

# misc
alias zshrc='${EDITOR:-vim} "${ZDOTDIR:-$HOME}"/.zshrc'
alias cls="clear && printf '\e[3J'"

# print things
alias print-fpath='for fp in $fpath; do echo $fp; done; unset fp'
alias print-path='echo $PATH | tr ":" "\n"'
alias print-functions='print -l ${(k)functions[(I)[^_]*]} | sort'

# auto-orient images based on exif tags
alias autorotate="jhead -autorot"

# noexpand
noexpand_aliases=(
  gpg
  grep
  ls
  vi
)

# vim: ft=zsh sw=2 ts=2 et
