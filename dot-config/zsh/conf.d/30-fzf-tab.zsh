# fzf-tab
zstyle ':fzf-tab:*' fzf-flags \
  --color=$FZF_COLORS \
  --highlight-line \
  --pointer ' ' \
  --marker '󰁔 ' \
  --prompt ':: ' \
  --border=none
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' popup-min-size 50 8
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

zstyle ':fzf-tab:complete:(-command-|-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
   '(tldr --color "$word" 2>/dev/null) || (MANWIDTH=$FZF_PREVIEW_COLUMNS MANPAGER= batman $word 2>/dev/null) || (which "$word") || echo ${(P)word}'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'git diff $word | delta'
zstyle 'fzf-tab:complete:git-log:*' fzf-preview \
  'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
  'case "$group" in
  "commit tag") git show --color=always $word ;;
  *) git show --color=always $word | delta ;;
  esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'case "$group" in
  "modified file") git diff $word | delta ;;
  "recent commit object name") git show --color=always $word | delta ;;
  *) git log --color=always $word ;;
  esac'

