case "$TERM" in
  xterm-color|*-256color) color_prompt=yes;;
esac

force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
  if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
    color_prompt=yes
  else
    color_prompt=
  fi
fi

if [ "$color_prompt" = yes ]; then
  # Override defualt virtualenv indicator
  VIRTUAL_ENV_DISABLE_PROMPT=1

  # enable syntax highlighting
  if [ -f /usr/share/zsh-syntax-highlighting.zsh ]; then
    ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
		ZSH_HIGHLIGHT_STYLES[default]=none
		ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[global-alias]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
		ZSH_HIGHLIGHT_STYLES[path]=underline
		ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
		ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[command-substitution]=none
		ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[process-substitution]=none
		ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
		ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
		ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta
		ZSH_HIGHLIGHT_STYLES[assign]=none
		ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
		ZSH_HIGHLIGHT_STYLES[named-fd]=none
		ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
		ZSH_HIGHLIGHT_STYLES[arg0]=fg=green
		ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
		ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
		ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
	fi
  else
    PROMPT='${debian_chroot:+($debian_chroot)}%n@%m:%~%# '
fi
unset color_prompt force_color_prompt 
