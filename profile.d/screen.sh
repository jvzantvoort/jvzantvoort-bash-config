#!/bin/bash

[[ "$-" =~ i ]] || return

SESSIONNAME=

# make sure our sockets arent removed from local systems
if [ ! -d "$HOME/.screen/${HOSTNAME}" ]
then
  mkdir -p "$HOME/.screen/${HOSTNAME}"
  chmod 700 "$HOME/.screen/${HOSTNAME}"
fi

export SCREENDIR="$HOME/.screen/${HOSTNAME}"

# screen specific config
# --------------------------------------
if [ ! -z "$STY" ]
then
  SESSIONNAME=$(echo $STY|awk -F'.' '{ print $NF }')
  if [ -f "$HOME/.bash/screenrc.d/${SESSIONNAME}.env" ]
  then
    source  "$HOME/.bash/screenrc.d/${SESSIONNAME}.env"
  fi
fi

export SESSIONNAME

_resume()
{
  local cur prev opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  prev="${COMP_WORDS[COMP_CWORD-1]}"
  if which tmux >/dev/null 2>&1
  then
    opts=$(ls -1d $HOME/.bash/tmux.d/*.rc|sed 's,.*\/\(.*\).rc,\1,')
  else
    opts=$(ls -1d $HOME/.bash/screenrc.d/*.rc|sed 's,.*\/\(.*\).rc,\1,')
  fi
  if [[ ${cur} == * ]]
  then
    if [[ ${#COMP_WORDS[@]} -gt 2 ]]
    then
      return 0
    else
      COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
      return 0
    fi
  fi
}

complete -F _resume resume


