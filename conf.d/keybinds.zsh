bindkey -e
stty -ixon

bindkey -v

bindkey '^N' down-history
bindkey '^P' up-history

bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

# Incremental search is elite!
bindkey -M vicmd "/" history-incremental-search-backward
bindkey -M vicmd "?" history-incremental-search-forward

# Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# This is killer.. try it!
bindkey -M vicmd "q" push-line

# Ensure that arrow keys work as they should
bindkey '\e[A' up-line-or-history
bindkey '\e[B' down-line-or-history

bindkey '\e0A' up-line-or-history # Search history with up arrow
bindkey '\e0B' down-line-or-history # Search history with down arrow

bindkey '\e0D' forward-char # Search history with right arrow
bindkey '\e0C' backward-char # Search history with left arrow

bindkey "^[[A" history-search-backward # Search history with up arrow
bindkey "^[[B" history-search-forward  # Search history with down arrow

# Like space AND completions. Gnarlbot
bindkey -M viins ' ' magic-space

# Push your line to the stack and run another command and then pop it back
bindkey -M vicmd '^q' push-line

bindkey '^F' forward-word
bindkey '^B' backward-word

bindkey '^X' create_completion

bindkey -M vicmd ' ' vi-easy-motion

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
