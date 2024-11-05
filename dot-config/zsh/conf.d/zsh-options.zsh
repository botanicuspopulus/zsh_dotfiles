setopt VI

setopt LOCAL_OPTIONS # allow function to have local options
setopt LOCAL_TRAPS # allow functions to have local traps

setopt NOBEEP
setopt NOLISTBEEP    # don't beep on tab completion
setopt NOHISTBEEP    # don't beep on history expansion
setopt NOHUP         # don't kill background jobs on exit
setopt NOBGNICE      # don't nice background tasks
setopt NOIGNOREEOF   # Don't exit on end of file

setopt NO_RM_STAR_SILENT # Ask for confirmation before executing 'rm *'
