if (( $+commands[nvim] )); then
  export EDITOR='nvim'
  alias nv=nvim
  alias vi=nvim
elif (( $+commands[vim] )); then
  export EDITOR='vim'
else
  export EDITOR='vi'
fi

export VISUAL="$EDITOR"


