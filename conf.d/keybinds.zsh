# Make sure that the terminal is in application mode when zle is active, since values from $terminfo are only valid then
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init() {
    echoti smkx
  }
  function zle-line-finish() {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi

bindkey -e
stty -ixon

bindkey -v

bindkey '^Y' accept-and-hold
bindkey '^Q' push-line-or-edit

# Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# This is killer.. try it!
bindkey -M vicmd "q" push-line

# Push your line to the stack and run another command and then pop it back
bindkey -M vicmd '^q' push-line

bindkey '^F' forward-word
bindkey '^B' backward-word

bindkey '^X' create_completion

# file rename magicks
bindkey "^[m" copy-prev-shell-word

bindkey -M vicmd ' ' vi-easy-motion

bindkey '^?' backward-delete-char # [Backspace] - delete backward
if [[ "${terminfo[kdch1]}" != "" ]]; then
  bindkey "$terminfo[kdch1]}" delete-char # [Delete] - delete forward
else
  bindkey "^[[3~" delete-char
  bindkey "^[3;5~" delete-char
  bindkey "\e[3~" delete-char
fi

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
