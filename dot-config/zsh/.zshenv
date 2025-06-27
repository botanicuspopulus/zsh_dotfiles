export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

export ZDOTDIR=${XDG_CONFIG_HOME:-$HOME/.config}/zsh

# Custom
export ASDF_DATA_DIR=$HOME/.asdf
export DOTFILES=$HOME/dotfiles
export REPO_HOME=${XDG_CACHE_HOME:-$HOME}/repos
export ANTIDOTE_HOME=$REPO_HOME
export GOPATH=$HOME/go

export LANG='en_US.UTF-8'

export LC_CTYPE='C.UTF-8'
export LANGUAGE='en_US.UTF-8'

typeset -gU cdpath fpath path

# Set the list of directories that zsh uses to search for programs
path=(
  $ASDF_DATA_DIR/shims
  $HOME/.local/bin(N)
  $HOME/{,s}bin(N)
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
