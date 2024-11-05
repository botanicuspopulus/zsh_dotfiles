# ls aliases
common_flags='--icons'
files_command="eza ${common_flags}"

common_ls_flags='--binary --classify=always'
ls_command="${files_command} ${common_ls_flags}"

alias ls="${ls_command}"
alias lsa="${ls_command} --all"
alias lls="${ls_command} --long"
alias llsa="${ls_command} --long --all"

alias lsd="${ls_command} --only-dirs"
alias lsad="${ls_command} --all --only-dirs"
alias llsd="${ls_command} --long --only-dirs"
alias llsad="${ls_command} --long --all --only-dirs"

alias lsf="${ls_command} --only-files"
alias llsf="${ls_command} --long --only-files"
alias lsaf="${ls_command} --all --only-files"

alias lss="${ls_command} --only-symlinks"
alias llss="${ls_command} --long --only-symlinks"
alias llsas="${ls_command} --long --all --only-symlinks"

tree_command="${files_command} --tree"
alias tree="${tree_command}"
alias treea="${tree_command} --all"

for level in {1..3}
do
  alias tree${level}="${tree_command} --level=${level}"
  alias tree${level}a="${tree_command} --level=${level} --all"
  alias tree${level}d="${tree_command} --level=${level} --only-dirs"
done
