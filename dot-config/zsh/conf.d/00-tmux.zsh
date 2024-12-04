[[ -z $TMUX ]] && tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf

tmux-which-key() {
  tmux show-wk-menu-root
}

zle -N tmux-which-key
bindkey -M vicmd " " tmux-which-key
