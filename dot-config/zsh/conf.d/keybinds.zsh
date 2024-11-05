bindkey -v
export KEYTIMEOUT=1

bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

bindkey '^w' backward-kill-word
bindkey '^h' backward-delete-char

bindkey '^p' history-substring-search-up
bindkey '^n' history-substring-search-down
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^k' kill-line
bindkey '^F' forward-word
bindkey '^B' backward-word

# Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# This is killer.. try it!
bindkey -M vicmd "q" push-line

# Push your line to the stack and run another command and then pop it back
bindkey -M vicmd '^q' push-line

# file rename magicks
bindkey "^[m" copy-prev-shell-word

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xi' vi-insert
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xh' accept-and-hold
bindkey -M menuselect '^xn' accept-and-infer-next-history
bindkey -M menuselect '^xu' undo

bindkey -M viins '\C-i' complete-word

# Accept autosuggestions with shift+tab
bindkey '^I' complete-word        # tab         | complete


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
