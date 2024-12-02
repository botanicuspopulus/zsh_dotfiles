# Environment variables and shell options for ZSH

# If globs do not match a file, just run the command rather than throwing a no-matches error.
# Especially useful for some commands with '^', '~', '#', e.g. 'git show HEAD^1'
unsetopt NOMATCH

setopt INTERACTIVE_COMMENTS
setopt NO_CORRECT
setopt LIST_PACKED
setopt NO_LIST_TYPES
setopt NO_CLOBBER
setopt NO_CASE_GLOB
setopt NO_GLOB_DOTS         # Don't match dotfiles
setopt NO_SH_WORD_SPLIT      # Use zsh style word splitting
setopt NUMERIC_GLOB_SORT

# In order to use #, ~, and ^ for filename generation grep word 
# *~(*.gz|*.zip|*.tar|*.tar.gz|*.tar.bz2|*.tar.xz|*.tar.zst) searches for word not in compressed files
setopt EXTENDED_GLOB 
setopt GLOB_COMPLETE
setopt MAGIC_EQUAL_SUBST # enable filename expansion for arguments of the form 'anything=expression'
setopt PROMPT_SUBST

WORDCHARS=''

# Path config
# Note: Configuring $PATH should preferably be done in the ~/.zshrc file in order that zsh plugins are also provisioned
# with exeutables from $PATH. Entries listed here may not be visible from zsh plugins and source scripts
path=( $path 
  $HOME/.cargo/bin 
  $HOME/go/bin
)
