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
[[ -d "/usr/homebin/bin" ]] || return

export PATH="$PATH:/usr/homebin/bin"
