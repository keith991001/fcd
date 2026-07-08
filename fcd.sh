# fcd — fuzzy cd into any directory under your home.
# Usage:
#   fcd            # open picker for all dirs
#   fcd <keyword>  # prefill picker with <keyword>; auto-cd if only one match
# Requires: fd, fzf

fcd() {
  local dir
  dir=$(fd -t d . ~ 2>/dev/null | fzf --select-1 --exit-0 --query "${1:-}") || return
  [ -n "$dir" ] && cd "$dir"
}
