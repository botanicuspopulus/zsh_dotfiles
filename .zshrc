source ~/.cache/repos/marlonrichert/zsh-autocomplete/zsh-autocomplete.plugin.zsh

[[ -r $ZDOTDIR/.zstyles ]] && source $ZDOTDIR/.zstyles

[[ -d $ANTIDOTE_HOME/mattmc3/antidote ]] ||
  git clone --depth 1 --quiet https://github.com/mattmc3/antidote $ANTIDOTE_HOME/mattmc3/antidote

source $ANTIDOTE_HOME/mattmc3/antidote/antidote.zsh
antidote load

autoload zmv

autoload -U compinit 
compinit -d $ZDOTDIR/.zcompdump

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done

autoenv_activate="$HOME/.autoenv/activate.sh"
if [[ -e "$autoenv_activate" ]]; then
  source "$autoenv_activate"
fi

xrdb ~/.Xresources

eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

zmodload zsh/net/tcp

[[ -z "$ZPROFRC" ]] || zprof

[[ -z "$TMUX" ]] && tmux -f $XDG_CONFIG_HOME/tmux/tmux.conf

neofetch

[[ -z "$HOME/.zshrc.local"]] && source "$HOME/.zshrc.local"
