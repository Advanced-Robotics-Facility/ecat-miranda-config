# Source from Bash or Zsh.
if [ -n "${BASH_VERSION:-}" ]; then
  source "$(dirname -- "${BASH_SOURCE[0]}")/setup.bash"
elif [ -n "${ZSH_VERSION:-}" ]; then
  source "${${(%):-%N}:A:h}/setup.zsh"
else
  printf '%s\n' 'Source setup.bash or setup.zsh from the corresponding shell.' >&2
  return 1
fi
