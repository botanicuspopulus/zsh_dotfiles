# vim ft=zsh
autoload -Uz vcs_info

zmodload -i zsh/complist

# Don't prompt for a huge list, page it!
unsetopt MENU_COMPLETE    # Do not auto select the first completion entry
unsetopt FLOW_CONTROL     # Disable start/stop characters in shell editor
unsetopt PATHDIRS

setopt AUTO_MENU          # show completion menu on successive tab press
setopt COMPLETE_IN_WORD   # Complete from both ends
setopt ALWAYS_TO_END      # Move cursor to the end of the complete word
setopt AUTO_PARAM_SLASH   # If completed parameter is a directtory, add a trailing slash
setopt completealiases    # don't expand aliases _before_ completion has finished
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
zstyle ':completion:*' menu select=2 # Show the menuif there are more than 2 items
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors "=(#b) #([0-9]#)*=36=31" # Color code completion!!!
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' completer _expand _complete _ignored _approximate _extensions

zstyle ':completion:*'                            verbose yes
zstyle ':completion:*:descriptions'               format '%F{green}%U%B%d%b%u%f'
zstyle ':completion:*:corrections'                format '%F{yellow}%U%B%d (errors:%e)%b%u'
zstyle ':completion:*:correct:*'                  original true
zstyle ':completion:*:matches:*'                  group 'yes'
zstyle ':completion:*'                            group-name '' # Group completions by type (file, external command, etc)

users=(williams wsmith williamsmith root)
zstyle ':completion:*' users $users

# Automatically complete 'cd -<tab>' and 'cd -<ctrd-d>' with menu
zstyle ':completion:*:*:cd:*:directory-stack'     menu yes select

zstyle ':completion:*:cd:*'                       tag-order local-directories directory-stack path-directories

# Insert all expansions for expand completer
zstyle ':completion:*:expand:*'                   tag-order all-expansions

zstyle ':completion:*:history-words'              stop yes
zstyle ':completion:*:history-words'              remove-all-dups yes
zstyle ':completion:*:history-words'              list false
zstyle ':completion:*:history-words'              menu yes

zstyle ':completion:*:messages'                   format '%d'
zstyle ':completion:*:options'                    auto-description '%d'
zstyle ':completion:*:options'                    description 'yes' # Describe optioins in full

zstyle ':completion:*:warnings'                   format '%F{orange}No matches for: %d'

# Define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'               ignored-patterns '(*~|*.zwc)'
zstyle ':completion:correct:'                     prompt 'Correct to: %e'

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
zstyle ':completion:*:man:*'                      menu yes select

# Provide more processes in completion of programs like killall
zstyle ':completion:*:processes-names'            command 'ps c -u $USER -o command | uniq'
zstyle ':completion:*:processes'                  command 'ps -au$USER -o pid,time,cmd | grep -v "ps -au$USER -o pid,time,cmd"'
zstyle ':completion:*:*:kill:*'                   menu yes select
zstyle ':completion:*:*:kill:*'                   force-list always
zstyle ':completion:*:*:kill:*'                   insert-ids single
zstyle ':completion:*:*:kill:*:processes'         list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'
zstyle ':completion:*:*:killall:*'                menu yes select
zstyle ':completion:*:*:killall:*'                force-list always
zstyle ':completion:*:*:killall:*:processes'      list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

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

zstyle ':completion:*:(ssh|scp|rsync):*'              tag-order 'hosts:-host:host hosts:-domain:domain hosts:-ip\ address *'
zstyle ':completion:*:(scp|rsync):*'                  group-order users files all-files hosts-domain hosts-host hosts-ipaddr
zstyle ':completion:*:ssh:*'                          group-order users hosts-domain hosts-host users hosts-ipaddr
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-host'   ignored-patterns '*(.|:)*' loopback ip6-loopback localhost ip6-localhost broadcasthost
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-domain' ignored-patterns '<->.<->.<->.<->' '^[-[:alnum:]]##(.[-[:alnum:]]##)##' '*@*'
zstyle ':completion:*:(ssh|scp|rsync):*:hosts-ipaddr' ignored-patterns '^(<->.<->.<->.<->|(|::)([[:xdigit:].]##:(#c,2))##(|%*))' '127.0.0.<->' '255.255.255.255' '::1' 'fe80::*'

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
