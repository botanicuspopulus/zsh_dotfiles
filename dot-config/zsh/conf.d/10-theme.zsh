export FZF_THEME_NAME="catppuccin-macchiato"

if [[ -f ${ZDOTDIR:-$HOME/.config}/themes/${FZF_THEME_NAME}.sh ]]; then
  source "${ZDOTDIR:-$HOME/.config}/themes/${FZF_THEME_NAME}.sh"
fi
