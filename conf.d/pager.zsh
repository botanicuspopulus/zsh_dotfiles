if (( $+commands[delta] )); then
  export GIT_PAGER=delta
fi

if (( $+commands[bat] )); then
  export BAT_PAGER="less -Rf"
fi

export PAGER="less"

# Set the default less options
# Mouse-wheel scrolling has been disabled by -X (disable screen clearin)
# Remove -X and -F (exit if the content fits on one screen) to enable it
export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the less input preprocessor
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

