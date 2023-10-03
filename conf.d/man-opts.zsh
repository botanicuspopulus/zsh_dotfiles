export MANOPT='--encoding=ascii --no-hyphenation --no-justification'

if (( $+commands[bat] )); then
  MANPAGER='bat --color=always --language=man --style=grid --decorations=always'
  MANPAGER="sh -c 'col -bx | ansifilter | $MANPAGER'"
  export MANPAGER
fi


export MANROFFOPT="-c"

