if (( $+commands[nvim] )) && [[ -z "$GIT_EDITOR" ]]; then
  export GIT_EDITOR="nvim"
fi

if (( $+commands[delta] )); then
  export GIT_PAGER=delta
fi

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git*:*' get-revision true
zstyle ':vcs_info:git*:*' check-for-changes true

# hash changes branches misc
zstyle ':vcs_info:git*' formats '(%s) %12.12i %c%u %b%m'
zstyle ':vsc_info:git*' actionformats '(%s|%a) %12.12i %c%u %b%m'

zstyle ':completion:*:git-checkout:*' sort false

