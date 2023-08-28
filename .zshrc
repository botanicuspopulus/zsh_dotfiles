source ~/.cache/repos/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh

[[ -s "$ZPROFRC" ]] || zmodload zsh/zprof
alias zprofrc="ZPROFRC=1 zsh"

[[ -r $ZDOTDIR/.zstyles ]] && source $ZDOTDIR/.zstyles

[[ -d $ANTIDOTE_HOME/mattmc3/antidote ]] ||
  git clone --depth 1 --quiet https://github.com/mattmc3/antidote $ANTIDOTE_HOME/mattmc3/antidote

source $ANTIDOTE_HOME/mattmc3/antidote/antidote.zsh
antidote load

autoload zmv

[[ -r $ZDOTDIR/conf.d/local.zsh ]] && source $ZDOTDIR/conf.d/local.zsh
[[ -r $ZDOTDIR/.zshrc.local ]] && source $ZDOTDIR/.zshrc.local

autoload -U compinit && compinit

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done

autoenv_activate="$HOME/.autoenv/activate.sh"
if [[ -e "$autoenv_activate" ]]; then
  source "$autoenv_activate"
fi

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

source "$HOME/.asdf/asdf.sh"

bindkey '^I' fzf_completion

[[ -z "$ZPROFRC" ]] || zprof

[[ -z "$TMUX" ]] && tmux
unset ZPROFRC zplugins
true


