source "$HOME/.asdf/asdf.sh"

for z in $ZDOTDIR/conf.d/*.zsh; do
  source "$z"
done
