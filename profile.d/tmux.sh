#!/bin/bash

[[ "$-" =~ i ]] || return
[[ -z "$TMUX" ]] && return

export SESSIONNAME=`tmux display-message -p '#S'`

# screen specific config
# --------------------------------------
if [ -f "$HOME/.bash/tmux.d/${SESSIONNAME}.env" ]
then
  "$HOME/.bash/bin/cprint" oke "${SESSIONNAME} found"
  source  "$HOME/.bash/tmux.d/${SESSIONNAME}.env"
else
  "$HOME/.bash/bin/cprint" nok "${SESSIONNAME} not found"

  return
fi
