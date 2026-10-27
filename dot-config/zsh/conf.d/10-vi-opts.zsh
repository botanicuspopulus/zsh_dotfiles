setopt VI

export KEYTIMEOUT=1

autoload -Uz select-bracketed select-quoted
zle -N select-quoted
zle -N select-bracketed
for km in viopp visual
do
  bindkey -M $km -- '-' vi-up-line-or-history
  for c in {a,i}${(s..)^:-\'\"\`\|,./:;=+@}
  do
    bindkey -M $km $c select-quoted
  done

  for c in {a,i}${(s..)^:-'()[]{}<>bB'}
  do
    bindkey -M $km $c select-bracketed
  done
done

autoload -Uz surround
zle -N delete-surround surround
zle -N add-surround surround
zle -N change-surround surround
bindkey -M vicmd cs change-surround
bindkey -M vicmd ds delete-surround
bindkey -M vicmd ys add-surround
bindkey -M visual S add-surround

# Search based on what you typed in already
bindkey -M vicmd "//" history-beginning-search-backward
bindkey -M vicmd "??" history-beginning-search-forward

# This is killer.. try it!
bindkey -M vicmd "q" push-line

# file rename magicks
bindkey "^[m" copy-prev-shell-word

zmodload -i zsh/complist

bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'l' vi-forward-char

bindkey -M menuselect '^xi' vi-insert
bindkey -M menuselect '^xg' clear-screen
bindkey -M menuselect '^xh' accept-and-hold
bindkey -M menuselect '^xn' accept-and-infer-next-history
bindkey -M menuselect '^xu' undo

# Allow backspace and friends to delete past the point where insert mode began
bindkey -M viins '^?' backward-delete-char
bindkey -M viins '^H' backward-delete-char
bindkey -M viins '^W' backward-kill-word
bindkey -M viins '^U' backward-kill-line

# Edit the current command line in $EDITOR
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line
bindkey -M viins '^X^E' edit-command-line

# Cursor shape: block in normal mode, beam in insert mode
zle-keymap-select() {
  [[ $KEYMAP == vicmd ]] && printf '\e[2 q' || printf '\e[6 q'
}
zle-line-init() { printf '\e[6 q' }
zle -N zle-keymap-select
zle -N zle-line-init
