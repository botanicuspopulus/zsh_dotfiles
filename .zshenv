export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state
export XDG_RUNTIME_DIR=$HOME/.xdg

export ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

# Custom
export DOTFILES=$HOME/dotfiles
export REPO_HOME=${XDG_CACHE_HOME:-$HOME}/repos
export ANTIDOTE_HOME=$REPO_HOME

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
  $XDG_DATA_HOME/gem/ruby/3.0.0/bin(N)
  $HOME/{,s}bin(N)
  $DOTFILES/bin(N)
  /{opt,usr}/local/{,s}bin(N)
  $path
)

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
