export MOZ_ENABLE_WAYLAND=1
export MOZ_DBUS_REMOTE=1
export GTK_CSD=0

GPG_TTY=$(tty)
export GPG_TTY
eval $(gpg-agent --daemon)
