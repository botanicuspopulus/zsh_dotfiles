# Replace the shell with tmux for local interactive terminals
if [[ -o interactive && -t 0 && -t 1 && -z $TMUX && -z $SSH_CONNECTION ]] && (( $+commands[tmux] )); then
  # Each terminal gets its own session grouped with 'main': same set of windows,
  # but each terminal can view a different window. Grouped sessions are
  # destroyed when their terminal closes.
  if tmux has-session -t main 2>/dev/null; then
    exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session -t main \; set-option destroy-unattached on
  else
    exec tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf new-session -s main
  fi
fi

tmux-which-key() {
  tmux show-wk-menu-root
}

zle -N tmux-which-key
bindkey -M vicmd " " tmux-which-key
