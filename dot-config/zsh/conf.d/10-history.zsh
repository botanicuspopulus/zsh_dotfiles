HISTSIZE=100000
SAVEHIST=100000

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
[[ -d ${HISTFILE:h} ]] || mkdir -p ${HISTFILE:h}

# Save timestamp and the duration as well as in the history file
setopt EXTENDED_HISTORY

# Write each command to the history file as it is entered and share it between all shells
setopt SHARE_HISTORY

setopt HIST_IGNORE_SPACE        # Don't record commands that start with a space
setopt HIST_EXPIRE_DUPS_FIRST   # Allow duplicates, but expire older ones when exceeding HISTSIZE
setopt HIST_IGNORE_ALL_DUPS     # Ignore duplicate commands
setopt HIST_FIND_NO_DUPS        # Do not find duplicates in history
setopt HIST_REDUCE_BLANKS       # Leave no blanks
setopt HIST_VERIFY              # Show the history expansion to be entered, without executing it
# setopt BANG_HIST                # !keyword
