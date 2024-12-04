export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"

source "$HOME/.asdf/asdf.sh"

eval "$(starship init zsh)"
eval "$(gh copilot alias -- zsh)"
eval "$(zoxide init zsh)"

source $ZDOTDIR/completion.zsh

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done
