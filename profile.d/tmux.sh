#!/bin/bash

[[ "$-" =~ i ]] || return
[[ -z "$TMUX" ]] && return

export SESSIONNAME=`tmux display-message -p '#S'`

# screen specific config
# --------------------------------------
[[ -f "$HOME/.bash/tmux.d/${SESSIONNAME}.env" ]] || return
source  "$HOME/.bash/tmux.d/${SESSIONNAME}.env"
