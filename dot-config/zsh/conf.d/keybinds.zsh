bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

bindkey -M viins '^E' autosuggest-accept
bindkey -M viins '^ ' autosuggest-execute
bindkey -M viins '^K' autosuggest-clear

bindkey -M vicmd ' ' vi-easy-motion

# Accept autosuggestions with shift+tab

### Fix slowness of pastes with zsh-syntax-highlighting
# Still needed as of 2023-06-24!
pasteinit() {
  # shellcheck disable=SC2296,SC2298
  OLD_SELF_INSERT=${${(s.:.)widgets[self-insert]}[2,3]}
  zle -N self-insert url-quote-magic
}

pastefinish() {
  zle -N self-insert $OLD_SELF_INSERT
}

zstyle :bracketed-paste-magic paste-init pasteinit
zstyle :bracketed-paste-magic paste-finish pastefinish
### End of slowness fix

# Suggest corrections for commmands
setopt correct
