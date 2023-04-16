#!/bin/bash

# colors prompts aren't needed on non-
# interactive screens
# --------------------------------------
[[ "$-" =~ i ]] || return

if [[ -f "${HOME}/.prompt.sh" ]]
then
  source "${HOME}/.prompt.sh"
else
  PS1="\[[1;36m\]\u@\h\[[0m\]/\[[0;32m\]redhat\[[0m\] $(__git_ps1 "(%s)") \T [\[[1;33m\]\w\[[0m\]]
# "
fi
