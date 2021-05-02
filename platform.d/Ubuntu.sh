#!/bin/bash

# enable color support of ls and also add handy aliases
if [[ -x "/usr/bin/dircolors" ]]
then
  if [[ -r "${HOME}/.dircolors" ]]
  then
    eval "$(dircolors -b ~/.dircolors)"
  else
    eval "$(dircolors -b)"
  fi
fi

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert

function alert()
{
  local err="$?"
  local lvl=""

  if [[ "${err}" == "0" ]]
  then
    lvl="terminal"
  else
    lvl="error"
  fi
  notify-send --urgency=low -i "${lvl}" \
    "$(history|tail -n1|sed -e 's/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//')"
}


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix
then
  if [[ -f /usr/share/bash-completion/bash_completion ]]
  then
    . "/usr/share/bash-completion/bash_completion"

  elif [[ -f /etc/bash_completion ]]
  then
    . "/etc/bash_completion"

  fi
fi
