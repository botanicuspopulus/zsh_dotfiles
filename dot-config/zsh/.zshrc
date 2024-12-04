source $ZDOTDIR/completion.zsh

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done

source "$HOME/.asdf/asdf.sh"

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"

zmodload zsh/net/tcp

[[ -r "$HOME/.zshrc.local" ]] && source "$HOME/.zshrc.local"

eval "$(gh copilot alias -- zsh)"
eval "$(fzf --zsh)"
eval "$(zoxide init zsh)"

# BEGIN ANSIBLE MANAGED BLOCK
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
# END ANSIBLE MANAGED BLOCK