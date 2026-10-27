# fzf-tab
zstyle ':fzf-tab:*' fzf-flags \
  --color=$FZF_COLORS \
  --highlight-line \
  --pointer ' ' \
  --marker '󰁔 ' \
  --prompt ':: ' \
  --border=none \
  --preview-window='right:55%:wrap,<100(down:50%:wrap)'

# Tab toggles selection by default; ctrl-space is the tmux prefix, so don't use it here
zstyle ':fzf-tab:*' fzf-bindings 'ctrl-a:toggle-all' 'ctrl-/:toggle-preview'
zstyle ':fzf-tab:*' fzf-min-height 15

# Generic file/dir preview for any command; more specific contexts below override it
zstyle ':fzf-tab:complete:*:*' fzf-preview \
  'fzf-preview $realpath'

# Outside tmux (e.g. over SSH) fzf-tab falls back to its default, plain fzf
if [[ -n $TMUX ]]; then
  zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
fi

zstyle ':fzf-tab:*' popup-min-size 100 20
zstyle ':fzf-tab:*' switch-group '<' '>'

zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o pid,ppid,%cpu,%mem,etime,cmd -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:4:wrap

zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status -- $word 2>/dev/null || SYSTEMD_COLORS=1 systemctl --user status -- $word'

zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-preview 'echo ${(P)word}'
zstyle ':fzf-tab:complete:tldr:argument-1' fzf-preview 'tldr --color $word'
zstyle ':fzf-tab:complete:-command-:*' fzf-preview \
   '(tldr --color "$word" 2>/dev/null) || (MANWIDTH=$FZF_PREVIEW_COLUMNS MANPAGER= batman $word 2>/dev/null) || which "$word"'

zstyle ':fzf-tab:complete:git-(add|diff|restore):*' fzf-preview \
  'd=$(git diff --color=always HEAD -- $word 2>/dev/null); [[ -n $d ]] && print -r -- $d | delta || fzf-preview $realpath'
zstyle ':fzf-tab:complete:git-log:*' fzf-preview \
  'git log --color=always $word'
zstyle ':fzf-tab:complete:git-show:*' fzf-preview \
  'case "$group" in
  "commit tag") git show --color=always $word ;;
  *) git show --color=always $word | delta ;;
  esac'
zstyle ':fzf-tab:complete:git-checkout:*' fzf-preview \
  'case "$group" in
  "modified file") git diff --color=always HEAD -- $word | delta ;;
  "recent commit object name") git show --color=always $word | delta ;;
  *) git log --color=always $word ;;
  esac'
zstyle ':fzf-tab:complete:(-parameter-|-brace-parameter-|export|unset|expand):*' \
  fzf-flags --preview-window=down:3:wrap
