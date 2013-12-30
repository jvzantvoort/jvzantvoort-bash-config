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

if [ -z "$SESSIONNAME" ]
then
  PS1="\[\033[0;36m\]\u@\h\[\033[0m\]/\[\033[0;36m\]centos\[\033[0m\] \T [\[\033[1;36m\]\w\[\033[0m\]]
# "
else
  PS1="\[\033[0;36m\]\u@\h\[\033[0m\]/\[\033[0;36m\]centos\[\033[0m\] ${PROMPT_Yellow}${SESSIONNAME}${PROMPT_END} \T [\[\033[1;36m\]\w\[\033[0m\]]
# "
fi
