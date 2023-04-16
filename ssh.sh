#!/bin/bash

[[ "$-" =~ i ]] || return

_ssh_completion()
{
  if [[ -e "${HOME}/.ssh/config" ]]
  then
    grep '^[[:blank:]]*Host[[:blank:]]' "${HOME}/.ssh/config" | \
      sed -e 's/Host//i' | tr ' ' \\n |sort -u | grep -v ^$ | tr \\n ' '
  fi
}

complete -W "$(_ssh_completion)" ssh 
