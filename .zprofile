export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export GTK_CSD=0

export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland

# qt wayland
export QT_STYLE_OVERRIDE=kvantum
export QT_QPA_PLATFORM=wayland
export QT_QPA_PLATFORMTHEME=qt5ct
export QT_WAYLAND_DISABLE_WINDOWDECORATION="1"

#Java XWayland blank screens fix
export _JAVA_AWT_WM_NONREPARENTING=1

GPG_TTY=$(tty)
export GPG_TTY
eval $(gpg-agent --daemon)
