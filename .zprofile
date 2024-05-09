export GPG_TTY="${TTY:-$(tty)}"

# Start gpg-agent if not already running
if ! pgrep -u "$UID" gpg-agent > /dev/null; then
    gpg-connect-agent /bye
fi
