# Replace the shell with tmux for local interactive terminals
if [[ -o interactive && -t 0 && -t 1 && -z $TMUX && -z $SSH_CONNECTION ]] && (( $+commands[tmux] )); then
  exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf
fi

tmux-which-key() {
  tmux show-wk-menu-root
}

zle -N tmux-which-key
bindkey -M vicmd " " tmux-which-key
