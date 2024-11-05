if (( $+commands[nvim] )) && [[ -z "$GIT_EDITOR" ]]; then
  export GIT_EDITOR="nvim"
fi

if (( $+commands[delta] )); then
  export GIT_PAGER=delta
fi


alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gpl='git pull'
alias gps='git push'
alias gpom='git push origin main'
alias ga='git add'
alias gaa='git add --all'
alias gd='git diff'
alias gsw='git switch'
alias gl='git log --one-line'
alias glo='git log --oneline'
alias glog='git log --oneline --graph --abbrev-commit --decorate'
alias gsu='git submodule update --init --recursive'

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

# hash changes branches misc
zstyle ':vcs_info:git*' formats '(%s) %12.12i %c%u %b%m'
zstyle ':vsc_info:git*' actionformats '(%s|%a) %12.12i %c%u %b%m'

zstyle ':completion:*:git-checkout:*' sort false

