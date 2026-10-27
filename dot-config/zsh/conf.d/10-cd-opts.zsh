setopt AUTO_PUSHD         # make cd push the old directory onto the directory stack
setopt PUSHD_IGNORE_DUPS  # don't push multiple copies of the same directory onto the directory stack
setopt PUSHD_SILENT       # don't print the directory stack after pushd or popd
setopt PUSHD_TO_HOME      # pushd with no arguments pushes to $HOME
setopt CDABLE_VARS
setopt PUSHD_MINUS
setopt CHASE_LINKS
DIRSTACKSIZE=20           # keep the directory stack from growing without bound
