#!/bin/bash

[[ "$-" =~ i ]] || return
[[ -z "$TMUX" ]] && return

SESSIONNAME=$(tmux display-message -p '#S')
export SESSIONNAME

SESSIONENVFILE=""

# screen specific config
# --------------------------------------
[[ -f "$HOME/.bash/tmux.d/${SESSIONNAME}.env" ]] && SESSIONENVFILE="$HOME/.bash/tmux.d/${SESSIONNAME}.env"
[[ -f "$HOME/.tmux.d/${SESSIONNAME}.env" ]] && SESSIONENVFILE="$HOME/.tmux.d/${SESSIONNAME}.env"

if [[ -n "${SESSIONENVFILE}" ]]
then
  "$HOME/.bash/bin/cprint" oke "${SESSIONNAME} found"
  source "${SESSIONENVFILE}"
else
  "$HOME/.bash/bin/cprint" nok "${SESSIONNAME} not found"

fi

unset SESSIONENVFILE
