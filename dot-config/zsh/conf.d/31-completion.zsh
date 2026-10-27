# vim ft=zsh
# Don't prompt for a huge list, page it!
unsetopt MENU_COMPLETE    # Do not auto select the first completion entry
unsetopt FLOW_CONTROL     # Disable start/stop characters in shell editor
unsetopt PATH_DIRS

# setopt AUTO_MENU          # show completion menu on successive tab press
setopt COMPLETE_IN_WORD   # Complete from both ends
setopt AUTO_PARAM_SLASH   # If completed parameter is a directtory, add a trailing slash

# General format of zstyle: ":completion:<func>:<completer>:<command>:<argument>:<tag>"
# <func> is the name of the function that is being called
# <completer> is the name of the completer that is being used
# <command> is the name of a command or similar context
# <argument> is the name of an argument to the command. Most useful for commands that take multiple arguments

zstyle ':completion:*' use-cache on   # Cache completions. Use rehash to clear
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu no # fzf-tab will try to complete unambiguous prefixes without user confirmation
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate _extensions

zstyle ':completion:*'                            verbose yes
zstyle ':completion:*:descriptions'               format '[%d]'
zstyle ':completion:*:matches:*'                  group 'yes'
zstyle ':completion:*'                            group-name '' # Group completions by type (file, external command, etc)
# Automatically complete 'cd -<tab>' and 'cd -<ctrd-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack'     menu yes select

zstyle ':completion:*:cd:*'                       tag-order local-directories directory-stack path-directories
zstyle ':fzf-tab:complete:cd:*'                   fzf-preview 'eza -1lh --icons --group-directories-first --color=always $realpath'

zstyle ':fzf-tab:complete:(cat|vim|nvim|less):argument-rest' fzf-preview '
  case $realpath in
    *.tar|*tar.gz|*.tgz|*.tar.bz2|*.tar.xz)
      tar tf $realpath 2>/dev/null ;;
    *.zip)
      unzip -l $realpath 2>/dev/null ;;
    *.md)
      glow -s $realpath 2>/dev/null ;;
    *)
      if [[ -d $realpath ]]; then
        eza -1 --icons --group-directories-first --color=always $realpath
      elif [[ -f $realpath ]]; then
        bat --style=numbers --color=always $realpath 2>/dev/null || head -n 40 $realpath
      fi ;;
  esac
'

# Insert all expansions for expand completer
zstyle ':completion:*:expand:*'                   tag-order all-expansions

zstyle ':completion:*:history-words'              stop yes
zstyle ':completion:*:history-words'              remove-all-dups yes
zstyle ':completion:*:history-words'              list false
# zstyle ':completion:*:history-words'              menu yes

zstyle ':completion:*:options'                    auto-description '%d'
zstyle ':completion:*:options'                    description 'yes' # Describe optioins in full

zstyle ':completion:*:warnings'                   format '%F{orange}%SNo matches for%s: %d%f'
zstyle ':completion:*:*:*:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'

# Define files to ignore for zcompile
zstyle ':completion:*:*:zcompile:*'               ignored-patterns '(*~|*.zwc)'

zstyle ':completion:*'                            list-dirs-first true
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

zstyle ':completion:*:(rm|vi|nv|vim|kill|diff):*'     ignore-line other # Don't complete stuff already on the line
zstyle ':completion:*:rm:*'                           file-patterns '*:all-files'

# Offer indexes before parameters in subscripts
zstyle ':completion:*:*:-subscript-:*'                tag-order indexes parameters # completion element sorting

zstyle ':completion:*:eza'                            sort false
zstyle ':completion:files'                            sort false

zstyle '*' single-ignored show  # Unless absolutely needed

# Don't mess up url passing as arguments
zstyle ':urlglobber' url-other-schema

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*~'

# Environment Variables
zstyle ':completion::*:(-command-|export):*' fake-parameters ${${${_comps[(I)-value-*]#*,}%%,*}:#-*-}

# compinit is run by the ez-compinit plugin, using $XDG_CACHE_HOME/zsh/zcompdump
