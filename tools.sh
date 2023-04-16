#!/bin/bash
#===============================================================================
#
#         FILE:  tools.sh
#
#        USAGE:  tools.sh
#
#  DESCRIPTION:  tools dir
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (jvzantvoort), John@vanZantvoort.org
#      COMPANY:  none
#      CREATED:  07-Aug-2017
#===============================================================================
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
