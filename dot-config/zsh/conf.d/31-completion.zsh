# vim ft=zsh
# Don't prompt for a huge list, page it!
unsetopt MENU_COMPLETE    # Do not auto select the first completion entry
unsetopt FLOW_CONTROL     # Disable start/stop characters in shell editor
unsetopt PATH_DIRS

# setopt AUTO_MENU          # show completion menu on successive tab press
setopt COMPLETE_IN_WORD   # Complete from both ends
setopt AUTO_PARAM_SLASH   # If completed parameter is a directtory, add a trailing slash
setopt ALWAYS_TO_END      # Move cursor to end of word after completing
setopt AUTO_LIST          # List choices on ambiguous completion
setopt LIST_PACKED        # Use variable column widths for tighter lists
_comp_options+=(globdots) # Complete dotfiles without typing the leading "."

# General format of zstyle: ":completion:<func>:<completer>:<command>:<argument>:<tag>"
# <func> is the name of the function that is being called
# <completer> is the name of the completer that is being used
# <command> is the name of a command or similar context
# <argument> is the name of an argument to the command. Most useful for commands that take multiple arguments

zstyle ':completion:*' use-cache on   # Cache completions. Use rehash to clear
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' menu no # fzf-tab will try to complete unambiguous prefixes without user confirmation
# Try exact, then case-insensitive, then word separators (f.b -> foo.bar), then substring
zstyle ':completion:*' matcher-list \
  '' 'm:{a-zA-Z}={A-Za-z}' 'm:{a-zA-Z}={A-Za-z} r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' completer _expand _complete _ignored _approximate _extensions

zstyle ':completion:*'                            verbose yes
zstyle ':completion:*:descriptions'               format '[%d]'
zstyle ':completion:*:matches:*'                  group 'yes'
zstyle ':completion:*'                            group-name '' # Group completions by type (file, external command, etc)
# Automatically complete 'cd -<tab>' and 'cd -<ctrd-d>' with menu
# zstyle ':completion:*:*:cd:*:directory-stack'     menu yes select

zstyle ':completion:*:cd:*'                       tag-order local-directories directory-stack path-directories
zstyle ':fzf-tab:complete:cd:*'                   fzf-preview 'fzf-preview $realpath'


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
zstyle ':completion:*'                            list-colors ${(s.:.)LS_COLORS}
# Complete hosts from ssh config and known_hosts only (not /etc/hosts, which may hold ad-blocking entries)
_ssh_config_hosts() {
  local -a cfg known
  cfg=(${(f)"$(cat ~/.ssh/config(N) /dev/null)"})
  cfg=(${${(M)cfg:#[[:space:]]#[Hh]ost[[:space:]]*}##[[:space:]]#[Hh]ost[[:space:]]##})
  known=(${(f)"$(cat ~/.ssh/known_hosts(N) /dev/null)"})
  known=(${${${known%%[ ,]*}#\[}%\]:*})
  reply=(${(u)${=cfg}:#*[*?]*} ${(u)known:#\|*})
}
zstyle -e ':completion:*:hosts' hosts '_ssh_config_hosts'
zstyle ':completion:*'                            squeeze-slashes true
zstyle ':completion:*'                            list-separator '  '
zstyle ':completion:*:match:*'                    original only # Note these need functions to be defined
# Allow 1 error for short words, len/3 for longer ones, never more than 3
zstyle -e ':completion:*:approximate:*' max-errors \
  'local -i len=$(( $#PREFIX + $#SUFFIX )); reply=( $(( len < 3 ? 1 : (len / 3 > 3 ? 3 : len / 3) )) numeric )'

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

zstyle ':completion:*:*:eza:*'                        sort false
zstyle ':completion:*'                                file-sort name

zstyle '*' single-ignored show  # Unless absolutely needed

# Don't mess up url passing as arguments
zstyle ':urlglobber' url-other-schema

# Don't complete backup files as executables
zstyle ':completion:*:complete:-command-::commands' ignored-patterns '*~'


# compinit is run by the ez-compinit plugin, using $XDG_CACHE_HOME/zsh/zcompdump
