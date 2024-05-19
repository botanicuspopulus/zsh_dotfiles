if (( $+commands[nvim] )) && [[ -z "$GIT_EDITOR" ]]; then
  export GIT_EDITOR="nvim"
fi
