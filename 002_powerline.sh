#!/bin/bash

[[ "$-" =~ i ]] || return

command -v powerline-daemon >/dev/null 2>&1 || return

powerline-daemon -q
POWERLINE_BASH_CONTINUATION=1
POWERLINE_BASH_SELECT=1

if [[ -f "/usr/share/powerline/bash/powerline.sh" ]]
then
  source /usr/share/powerline/bash/powerline.sh
fi
