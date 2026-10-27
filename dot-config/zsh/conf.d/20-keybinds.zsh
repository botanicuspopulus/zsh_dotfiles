bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

# Quote special characters (?, &, #) in URLs as they are pasted or typed
autoload -Uz bracketed-paste-magic url-quote-magic
zle -N bracketed-paste bracketed-paste-magic
zle -N self-insert url-quote-magic

bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^ ' autosuggest-execute
bindkey -M viins '^K' autosuggest-clear

# zsh-history-substring-search
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
# Application-mode arrow keys (^[OA/^[OB) as reported by terminfo
bindkey -M viins "$terminfo[kcuu1]" history-substring-search-up
bindkey -M viins "$terminfo[kcud1]" history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# zsh-autosuggestions (read when the plugin loads later)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
