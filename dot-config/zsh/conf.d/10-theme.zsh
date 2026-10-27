export FZF_THEME_NAME="catppuccin-macchiato"

if [[ -f ${ZDOTDIR:-$HOME/.config/zsh}/themes/${FZF_THEME_NAME}.sh ]]; then
  source "${ZDOTDIR:-$HOME/.config/zsh}/themes/${FZF_THEME_NAME}.sh"
fi

# File type colours for completion menus and fzf-tab
if (( $+commands[dircolors] )); then
  eval "$(dircolors -b)"
fi
