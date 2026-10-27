bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^ ' autosuggest-execute
bindkey -M viins '^K' autosuggest-clear

# zsh-history-substring-search
bindkey -M viins '^[[A' history-substring-search-up
bindkey -M viins '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# zsh-autosuggestions (read when the plugin loads later)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_MANUAL_REBIND=1
