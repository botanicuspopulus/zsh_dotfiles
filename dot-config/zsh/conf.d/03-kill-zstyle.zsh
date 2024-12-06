# Provide more processes in completion of programs like killall
zstyle ':completion:*:processes-names'            command 'ps c -u $USER -o command | uniq'
zstyle ':completion:*:processes'                  command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':completion:*:*:kill:*'                   force-list always
zstyle ':completion:*:*:kill:*'                   insert-ids single
zstyle ':completion:*:*:kill:*:processes'         list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'
zstyle ':completion:*:*:killall:*'                force-list always
zstyle ':completion:*:*:killall:*:processes'      list-colors '=(#b) #([0-9]#)[ 0-9:]#([^ ]#)*=01;30=01;31=01;38'

