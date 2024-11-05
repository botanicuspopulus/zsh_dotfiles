[[ -r $ZDOTDIR/.zstyles ]] && source $ZDOTDIR/.zstyles

autoload -Uz compinit 
compinit

zmodload -i zsh/complist
zmodload -i zsh/parameter
zmodload -i zsh/mathfunc

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

zmodload zsh/net/tcp

[[ -z "$TMUX" ]] && tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

source "$HOME/.asdf/asdf.sh"

eval "$(gh copilot alias -- zsh)"
eval "$(fzf --zsh)"
#
# BEGIN ANSIBLE MANAGED BLOCK
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# END ANSIBLE MANAGED BLOCK
