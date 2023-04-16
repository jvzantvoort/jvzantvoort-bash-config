#!/bin/bash
[[ "$-" =~ i ]] || return

if [ -d "/usr/homebin/bin" ]
then
  export PATH="$PATH:/usr/homebin/bin"
  return
fi

if [ -d "$HOME/.tools/bin" ]
then
  export PATH="$PATH:$HOME/.tools/bin"
  return
fi
