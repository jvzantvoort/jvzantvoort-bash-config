#===============================================================================
#
#         FILE:  ~/.bashrc
#
#  DESCRIPTION:  local bash configuration
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (JvZ), <john.van.zantvoort@snow.nl>
#      CREATED:  
#     REVISION:  $Revision: 1.6 $
#===============================================================================

[ -z "$TTY_NAME" ] || echo -e " \033[0;32m*\033[0m hostname:workstation profile sourced"

[[ -z "$SESSIONNAME" ]] && return

