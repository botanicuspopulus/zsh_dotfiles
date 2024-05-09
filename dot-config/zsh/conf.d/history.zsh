export HISTSIZE=100000
export SAVEHIST=100000

# Save timestamp and the duration as well as in the history file
setopt EXTENDED_HISTORY

# New history lines are added incrementally as soon as they are entered rather than 
# waiting until the shell exists
setopt INC_APPEND_HISTORY

setopt APPEND_HISTORY

# Don't want to share command history
unsetopt SHARE_HISTORY
setopt NO_SHARE_HISTORY

setopt HIST_EXPIRE_DUPS_FIRST   # Allow duplicates, but expire older ones when exceeding HISTSIZE
setopt HIST_IGNORE_ALL_DUPS     # Ignore duplicate commands
setopt HIST_FIND_NO_DUPS        # Do not find duplicates in history
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_SPACE        # Ignore entries starting with a space
setopt HIST_REDUCE_BLANKS       # Leave no blanks
setopt HIST_SAVE_NO_DUPS        # Do not save duplicates
setopt HIST_VERIFY
