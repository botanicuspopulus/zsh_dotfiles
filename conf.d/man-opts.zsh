export MANOPT='--encoding=ascii --no-hyphenation --no-justification'

MANPAGER='bat --color=always --language=man --style=grid --decorations=always'
MANPAGER="sh -c 'col -bx | ansifilter | $MANPAGER'"

export MANPAGER

export MANROFFOPT="-c"

