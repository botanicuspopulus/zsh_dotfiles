# Shared eza flags; also used by fzf previews (20-fzf-opts.zsh, bin/fzf-preview)
export EZA_COMMON='--group-directories-first'

# Anonymous function keeps the helper variables local
() {
  (( $+commands[eza] )) || return

  # ls aliases
  local files_command="eza ${EZA_COMMON} --icons=auto"

  local common_ls_flags='--binary --classify=always'
  local ls_command="${files_command} ${common_ls_flags}"
  local lls_command="${ls_command} --long --git --header --time-style=relative"

  alias ls="${ls_command}"
  alias lsa="${ls_command} --all"
  alias lls="${lls_command}"
  alias llsa="${lls_command} --all"

  alias lsd="${ls_command} --only-dirs"
  alias lsad="${ls_command} --all --only-dirs"
  alias llsd="${lls_command} --only-dirs"
  alias llsad="${lls_command} --all --only-dirs"

  alias lsf="${ls_command} --only-files"
  alias llsf="${lls_command} --only-files"
  alias lsaf="${ls_command} --all --only-files"

  # eza has no --only-symlinks; use zsh glob qualifiers (@ = symlink, D = dotfiles)
  eval "lss()   { local -a f=(*(N@));  (( \$#f )) && ${ls_command} -d -- \$f }"
  eval "llss()  { local -a f=(*(N@));  (( \$#f )) && ${lls_command} -d -- \$f }"
  eval "llsas() { local -a f=(*(ND@)); (( \$#f )) && ${lls_command} -d -- \$f }"

  local tree_command="${files_command} --tree --git-ignore"
  alias tree="${tree_command}"
  alias treea="${tree_command} --all"

  local level
  for level in {1..3}
  do
    alias tree${level}="${tree_command} --level=${level}"
    alias tree${level}a="${tree_command} --level=${level} --all"
    alias tree${level}d="${tree_command} --level=${level} --only-dirs"
  done
}
