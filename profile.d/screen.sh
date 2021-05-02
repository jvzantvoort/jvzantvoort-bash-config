#!/bin/bash

[[ "$-" =~ i ]] || return

SESSIONNAME=

function _get_session_name()
{
  echo "$STY"|awk -F'.' '{ print $NF }'
}

# make sure our sockets arent removed from local systems
if [ ! -d "$HOME/.screen/${HOSTNAME}" ]
then
  mkdir -p "$HOME/.screen/${HOSTNAME}"
  chmod 700 "$HOME/.screen/${HOSTNAME}"
fi

export SCREENDIR="$HOME/.screen/${HOSTNAME}"

# screen specific config
# --------------------------------------
SESSIONNAME="$(_get_session_name)"

if [[ -n "${SESSIONNAME}" ]]
then
  if [ -f "$HOME/.bash/screenrc.d/${SESSIONNAME}.env" ]
  then
    #shellcheck disable=SC1090
    source  "$HOME/.bash/screenrc.d/${SESSIONNAME}.env"
  fi
fi

export SESSIONNAME

unset _get_session_name
