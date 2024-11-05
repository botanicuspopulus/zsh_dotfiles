bindkey -v
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
