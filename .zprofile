if [ "$XDG_SESSION_DESKTOP" = "sway" ]; then
  export _JAVA_AWT_WM_NONPARENTING=1
  if [[ -f /dev/dri/card1 ]]; then
    export WLR_DRM_DEVICES=/dev/dri/card1
  fi
fi

export QT_QPA_PLATFORMTHEME=qt6ct

GPG_TTY=$(tty)
export GPG_TTY
eval $(gpg-agent --daemon)
