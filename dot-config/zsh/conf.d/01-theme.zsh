export FZF_THEME_NAME="tokyonight_night"

if [[ -f ${ZDOTDIR:-$HOME/.config}/themes/${FZF_THEME_NAME}.sh ]]; then
  source "${ZDOTDIR:-$HOME/.config}/themes/${FZF_THEME_NAME}.sh"
fi
