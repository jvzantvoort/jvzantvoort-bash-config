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

pathmunge "${HOME}/.bashrc.d/bin"
