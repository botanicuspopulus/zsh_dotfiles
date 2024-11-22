source $ZDOTDIR/completion.zsh

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done

source "$HOME/.asdf/asdf.sh"

source $ZDOTDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $ZDOTDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $ZDOTDIR/plugins/zsh-easy-motion/easy_motion.plugin.zsh
source $ZDOTDIR/plugins/fancy-ctrl-z/fancy-ctrl-z.zsh
source $ZDOTDIR/plugins/z.zsh

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

zmodload zsh/net/tcp

[[ -z "$TMUX" ]] && tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

eval "$(gh copilot alias -- zsh)"
eval "$(fzf --zsh)"

# BEGIN ANSIBLE MANAGED BLOCK
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# END ANSIBLE MANAGED BLOCK