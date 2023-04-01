#!/bin/bash
#===============================================================================
#
#         FILE:  ~/.bashrc.CentOS
#
#  DESCRIPTION:  local bash CentOS configuration
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (JvZ), <john.van.zantvoort@snow.nl>
#      CREATED:  
#     REVISION:  $Revision: 1.6 $
#===============================================================================

LC_ALL=C
[[ "$-" =~ i ]] || return

"$HOME/.bash/bin/cprint" platform CentOS
