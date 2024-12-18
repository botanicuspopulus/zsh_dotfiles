# vim ft=zsh
autoload -Uz vcs_info

zmodload -i zsh/complist

# Don't prompt for a huge list, page it!
unsetopt MENU_COMPLETE    # Do not auto select the first completion entry
unsetopt FLOW_CONTROL     # Disable start/stop characters in shell editor
unsetopt PATH_DIRS

# setopt AUTO_MENU          # show completion menu on successive tab press
setopt COMPLETE_IN_WORD   # Complete from both ends
setopt ALWAYS_TO_END      # Move cursor to the end of the complete word
setopt AUTO_PARAM_SLASH   # If completed parameter is a directtory, add a trailing slash
setopt COMPLETE_ALIASES    # don't expand aliases _before_ completion has finished
setopt LIST_AMBIGUOUS     # Complete as much of a completion until it gets ambiguous
setopt HASH_LIST_ALL      # Hash everything before completion

# General format of zstyle: ":completion:<func>:<completer>:<command>:<argument>:<tag>"
# <func> is the name of the function that is being called
# <completer> is the name of the completer that is being used
# <command> is the name of a command or similar context
# <argument> is the name of an argument to the command. Most useful for commands that take multiple arguments

zstyle ':autocomplete:*' ignored-input '..##'

zstyle ':completion:*' use-cache on   # Cache completions. Use rehash to clear
zstyle ':completion:*' cache-path "XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu no # fzf-tab will try to complete unambiguous prefixes without user confirmation
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate _extensions

zstyle ':completion:*'                            verbose yes
zstyle ':completion:*:descriptions'               format '[%d]'
zstyle ':completion:*:matches:*'                  group 'yes'
zstyle ':completion:*'                            group-name '' # Group completions by type (file, external command, etc)

users=(williams wsmith williamsmith root)
zstyle ':completion:*' users $users

# Automatically complete 'cd -<tab>' and 'cd -<ctrd-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack'     menu yes select

zstyle ':completion:*:cd:*'                       tag-order local-directories directory-stack path-directories

# Insert all expansions for expand completer
zstyle ':completion:*:expand:*'                   tag-order all-expansions

zstyle ':completion:*:history-words'              stop yes
zstyle ':completion:*:history-words'              remove-all-dups yes
zstyle ':completion:*:history-words'              list false
# zstyle ':completion:*:history-words'              menu yes

zstyle ':completion:*:messages'                   format '%d'
zstyle ':completion:*:options'                    auto-description '%d'
zstyle ':completion:*:options'                    description 'yes' # Describe optioins in full

zstyle ':completion:*:warnings'                   format '%F{orange}%SNo matches for%s: %d%f'

# Define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'               ignored-patterns '(*~|*.zwc)'

zstyle ':completion:*'                            list-dirs-first true
zstyle ':completion:*'                            file-sort modification reverse # Have the newer files last so I see them first
zstyle ':completion:*'                            hosts off # Don't tab complete hosts (slow and if you have ad-blocking in your hosts files annoying)
zstyle ':completion:*'                            squeeze-slashes true
zstyle ':completion:*'                            list-separator '  '
zstyle ':completion:*:match:*'                    original only # Note these need functions to be defined
zstyle ':completion:*:approximate:*'              max-errors "reply=(  $((($#PREFIX + $#SUFFIX) / 3)) numeric )" # More errors allowed for large words and fewer for small words

# Complete manuals by their section
zstyle ':completion:*:manuals'                    separate-sections true
zstyle ':completion:*:manuals.*'                  insert-sections true

# Ignore completion functions for commands that you don't have
zstyle ':completion::(^approximate*):*:functions' ignored-patterns '_*'
zstyle ':completion:*:functions'                  ignored-patterns '(_*|pre(cmd|exec)|prompt_*)'  # ignores unavailable commands

# Provide .. as a completion
zstyle ':completion:*'                            special-dirs ..

# Run rehash on completion so new installed programs are found automatically
function _force_rehash() { 
  (( CURRENT == 1 )) && rehash
  return 1
}

zstyle ':completion:*:(rm|vi|nv|vim|kill|diff):*'     ignore-line other # Don't complete stuff already on the line
zstyle ':completion:*:rm:*'                           file-patterns '*:all-files'

# Offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*'                tag-order indexes parameters # completion element sorting

zstyle ':completion:*:eza'                            sort false
zstyle ':completion:files'                            sort false

zstyle ':zel:*-word-shell'                            word-style shell

zle -N forward-word-shell forwad-word-match
zle -N backward-word-shell backward-word-match

zstyle '*' single-ignored show  # Unless absolutely needed

if [[ -s "$DOTFILES/neomutt/aliases" ]]; then
  zstyle ':completion:*:mutt:*' menu yes select
  zstyle ':completion:*:mutt:*' users ${${${(f)"$(<"$DOTFILES/neomutt/aliases")"}#alias[[:space:]]}%%[[:space:]]*}
fi

# Don't mess up url passing as arguments
zstyle ':urlglobber' url-other-schema

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*~'

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

zstyle ':zle:edit-command-line' editor nvim
