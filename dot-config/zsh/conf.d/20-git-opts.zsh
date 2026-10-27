if (( $+commands[nvim] )) && [[ -z "$GIT_EDITOR" ]]; then
  export GIT_EDITOR="nvim"
fi

if (( $+commands[delta] )); then
  export GIT_PAGER=delta
fi
