export GPG_TTY="${TTY:-$(tty)}"
# gpg-agent is started on demand by systemd socket activation (gpg-agent.socket)

# Set PATH here rather than in .zshenv so it is applied after /etc/zsh/zprofile
# (which sources /etc/profile) and keeps this ordering
export PYENV_ROOT="$HOME/.pyenv"

path=(
  $HOME/.local/bin(N)
  $HOME/{,s}bin(N)
  $HOME/.opencode/bin(N)
  $HOME/.npm-global/bin(N)
  $PYENV_ROOT/bin(N)
  /{opt,usr}/local/{,s}bin(N)
  $path
  $HOME/.cargo/bin(N)
  $GOPATH/bin(N)
)
