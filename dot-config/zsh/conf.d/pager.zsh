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

# Support colors in less
export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
export LESS_TERMCAP_me=$'\E[0m'           # end mode
export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'           # end underline
export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline
