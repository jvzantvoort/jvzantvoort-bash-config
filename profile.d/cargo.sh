#!/bin/bash
#===============================================================================
#
#         FILE:  cargo.sh
#
#        USAGE:  cargo.sh
#
#  DESCRIPTION:  cargo dir
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (jvzantvoort), John@vanZantvoort.org
#      COMPANY:  none
#      CREATED:  05-Sep-2022
#===============================================================================
[[ "$-" =~ i ]] || return

if [ -d "$HOME/.cargo/bin" ]
then
  export PATH="$PATH:$HOME/.cargo/bin"
  return
fi
