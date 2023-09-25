if [ "$XDG_SESSION_DESKTOP" = "sway" ]; then
  export _JAVA_AWT_WM_NONPARENTING=1
  export WLR_DRM_DEVICES=/dev/dri/card1
fi
