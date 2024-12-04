export MANOPT='--encoding=ascii --no-hyphenation --no-justification'

if (( $+commands[bat] )); then
  MANPAGER='bat --color=always --language=man --plain'
  MANPAGER="sh -c 'col -bx | ansifilter | $MANPAGER'"
  export MANPAGER
fi

export MANROFFOPT="-c"

