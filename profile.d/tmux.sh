#!/bin/bash

[[ "$-" =~ i ]] || return
[[ -z "$TMUX" ]] && return

SESSIONNAME=$(tmux display-message -p '#S')
export SESSIONNAME

# screen specific config
# --------------------------------------
if [ -f "$HOME/.bash/tmux.d/${SESSIONNAME}.env" ]
then
  "$HOME/.bash/bin/cprint" oke "${SESSIONNAME} found"
   #shellcheck disable=SC1090
  source  "$HOME/.bash/tmux.d/${SESSIONNAME}.env"
else
  "$HOME/.bash/bin/cprint" nok "${SESSIONNAME} not found"

  return
fi
