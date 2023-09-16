
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=$HOME/.xdg

export ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

if (( $+commands[delta] )); then
  export GIT_PAGER=delta
fi

# if (( $+commands[vivid] )); then
#   export LS_COLORS="$(vivid generate tokyonight_night)"
# fi

if (( $+commands[bat] )); then
  export BAT_PAGER="less -Rf"
fi

export PAGER="less"

if (( $+commands[rg] )); then
  export RIPGREP_CONFIG_PATH="${XDG_CONFIG_HOME:-$HOME/.config}/ripgrep/ripgreprc"
fi

# Custom
export DOTFILES=$HOME/dotfiles
export REPO_HOME=${XDG_CACHE_HOME:-$HOME}/repos
export ANTIDOTE_HOME=$REPO_HOME

if (( $+commands[cheat] )); then
  export CHEAT_CONFIG_PATH=${XDG_CONFIG_HOME:-$HOME}/cheat/conf.yml
  export CHEAT_USE_FZF=true
fi

if (( $+commands[nvim] )); then
  export EDITOR='nvim'
  export VISUAL='nvim'
else
  export EDITOR='vim'
  export VISUAL='vim'
fi

if [[ -z "$LANG" ]]; then
  export LANG='en_US.UTF-8'
fi

if [[ "$LC_CTYPE" == "UTF-8" ]]; then
  export LC_CTYPE='en_US.UTF-8'
fi

typeset -gU cdpath fpath path

# Set the list of directories that zsh uses to search for programs
path=(
  $HOME/.local/bin(N)
  $HOME/perl5/bin(N)
  $HOME/{,s}bin(N)
  /{opt,usr}/local/{,s}bin(N)
  $path
)

PERL5LIB="$HOME/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="$HOME/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"$HOME/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=$HOME/perl5"; export PERL_MM_OPT;

# Set the default less options
# Mouse-wheel scrolling has been disabled by -X (disable screen clearin)
# Remove -X and -F (exit if the content fits on one screen) to enable it
# export LESS='-F -g -i -M -R -S -w -X -z-4'

# Set the less input preprocessor
if (( $+commands[lesspipe.sh] )); then
  export LESSOPEN='| /usr/bin/env lesspipe.sh %s 2>&-'
fi

# Place to put temp files
if [[ -d "$TMPDIR" ]]; then
  export TMPPREFIX="${TMPDIR%/}/zsh"
  [[ ! -d "$TMPPREFIX" ]] || mkdir -p "$TMPPREFIX"
fi

# Custom config directory
fpath=(
  ${ZDOTDIR:-$HOME}/functions
  $XDG_DATA_HOME/zsh/site-function
  ${ZDOTDIR:-HOME}/completions
  $fpath
)

# Disable dot files in archive
export COPYFILE_DISABLE=true

if [ -f "$HOME/.zshenv.local" ]; then
  source "$HOME/.zshenv.local"
fi
