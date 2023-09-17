#!/bin/bash

[[ "$-" =~ i ]] || return
[[ -z "$TMUX" ]] && return

SESSIONNAME=$(tmux display-message -p '#S')
export SESSIONNAME

function _findsession()
{
    for dirn in "$HOME/.bash/tmux.d" "$HOME/.tmux.d"
    do
        find "${dirn}" -type f -name "$1.env"
    done | head -n 1
}

SESSION_ENV="$(_findsession "${SESSIONNAME}")"

if [[ -n "${SESSION_ENV}" ]]
then
  printf "Source %s\n" "${SESSION_ENV}"
  source "${SESSION_ENV}"
fi
