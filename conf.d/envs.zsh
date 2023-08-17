# Environment variables and shell options for ZSH

# If globs do not match a file, just run the command rather than throwing a no-matches error.
# Especially useful for some commands with '^', '~', '#', e.g. 'git show HEAD^1'
unsetopt NOMATCH

setopt VI 
setopt INTERACTIVE_COMMENTS
setopt ALWAYS_TO_END 
setopt COMPLETE_IN_WORD 
setopt NO_CORRECT 
setopt LIST_AMBIGUOUS 
setopt LIST_PACKED 
setopt HASH_LIST_ALL 
setopt NO_LIST_TYPES 
setopt AUTO_MENU 
setopt NO_LIST_BEEP 
setopt NO_CLOBBER 
setopt NO_CASE_GLOB 
setopt NUMERIC_GLOB_SORT 
setopt EXTENDED_GLOB 
setopt GLOB_COMPLETE 
setopt MAGIC_EQUAL_SUBST # enable filename expansion for arguments of the form 'anything=expression'
setopt PROMPT_SUBST
 
WORDCHARS=''
unsetopt MENU_COMPLETE
unsetopt FLOWCONTROL

if [[ -f /proc/sys/fs/binfmt_misc/WSLInterop ]]; then
  umask 022
  alias open=explorer.exe
  alias pbcopy=clip.expe
  alias pbpaste='pwsh Get-Clipboard | sed "s/\r$//" | head -c -1'
fi


# Path config
# Note: Configuring $PATH should preferably be done in the ~/.zshrc file in order that zsh plugins are also provisioned
# with exeutables from $PATH. Entries listed here may not be visible from zsh plugins and source scripts
path=( $path $HOME/.cargo/bin )
