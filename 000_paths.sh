#!/bin/bash

[[ "$-" =~ i ]] || return

function pathmunge()
{
  local dirn="$1"
  [[ -z "${dirn}" ]] && return
  [[ -d "${dirn}" ]] || return

  if echo "$PATH" | grep -E -q "(^|:)$1($|:)"
  then
    return
  fi

  if [[ "$2" = "after" ]]
  then
    PATH=$PATH:$1
  else
    PATH=$1:$PATH
  fi
}

pathmunge "/bin"
pathmunge "/usr/bin"
pathmunge "/usr/local/bin"

pathmunge "/sbin"
pathmunge "/usr/sbin"
pathmunge "/usr/local/sbin"

pathmunge "${HOME}/bin" "after"
pathmunge "${HOME}/.bashrc.d/bin"
pathmunge "${HOME}/.local/bin"

if command -v path_clean >/dev/null 2>&1
then
  PATH="$(path_clean)"
fi

export PATH
