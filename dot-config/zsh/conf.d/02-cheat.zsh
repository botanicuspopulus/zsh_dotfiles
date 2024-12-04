if (( $+commands[cheat] )); then
  export CHEAT_CONFIG_PATH=${XDG_CONFIG_HOME:-$HOME}/cheat/conf.yml
  export CHEAT_USE_FZF=true
fi
