export GPG_TTY="${TTY:-$(tty)}"

# Start gpg-agent if not already running
if ! pgrep -u "$UID" gpg-agent > /dev/null; then
    gpg-connect-agent /bye
fi

export QSYS_ROOTDIR="/home/williamsmith/intelFPGA_pro/22.1/qsys/bin"
