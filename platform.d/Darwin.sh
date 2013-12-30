#===============================================================================
#
#         FILE:  .bashrc.Darwin
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

LC_ALL=en_US.UTF-8
LC_CTYPE=UTF-8
LANG=en_US.UTF-8
export LC_ALL LC_CTYPE LANG

export PATH=/opt/local/bin:/opt/local/sbin:/Applications/MacPorts/MacVim.app/Contents/MacOS:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin:/Users/johnvanzantvoort/bin

if [ -f "$HOME/.netw" ]
then
  . $HOME/.netw
fi

if [ -x "/Applications/MacPorts/MacVim.app/Contents/MacOS/Vim" ]
then
  alias vim=Vim
  alias gvim='Vim -g'
  alias edit='open -a MacVim'
fi
EDITOR=vim
SVN_EDITOR=$EDITOR

# some local variable definitions
# --------------------------------------
MYHOST=`uname -n | sed 's!\..*$!!'`

# Set the perty prompt colors
# --------------------------------------
if tty 1>/dev/null 2>&1
then
  if [ -f "${HOME}/.aliasses" ]
  then
    . ${HOME}/.aliasses
  else
    alias ll='/bin/ls -lA'
  fi

  PROMPT_END='\[\033[0m\]'
  PROMPT_BLACK='\[\033[0:30m\]'
  PROMPT_GRAY='\[\033[1:30m\]'
  PROMPT_Black='\[\033[0;30m\]'
  PROMPT_Dark_Gray='\[\033[1;30m\]'
  PROMPT_Blue='\[\033[0;34m\]'
  PROMPT_Light_Blue='\[\033[1;34m\]'
  PROMPT_Green='\[\033[0;32m\]'
  PROMPT_Light_Green='\[\033[1;32m\]'
  PROMPT_Cyan='\[\033[0;36m\]'
  PROMPT_Light_Cyan='\[\033[1;36m\]'
  PROMPT_Red='\[\033[0;31m\]'
  PROMPT_Light_Red='\[\033[1;31m\]'
  PROMPT_Purple='\[\033[0;35m\]'
  PROMPT_Light_Purpl='\[\033[1;35m\]'
  PROMPT_Brown='\[\033[0;33m\]'
  PROMPT_Yellow='\[\033[1;33m\]'
  PROMPT_Light_Gray='\[\033[0;37m\]'
  PROMPT_White='\[\033[1;37m\]'

  PROMPT_Color=$PROMPT_Cyan

  if [ -f "${HOME}/.prompt" ]
  then
    . "${HOME}/.prompt"
  fi
  OS_VAR="\[\033[0;36m\]MAC\[\033[0m\]"
  PS1=$PROMPT_Color'\u@mac'$PROMPT_END' \T ['$PROMPT_Yellow'\w'$PROMPT_END']
# '

  # might not be needed but neat nonetheless
  unset PROMPT_Color
  unset OS_VAR
  unset PROMPT_END
  unset PROMPT_BLACK
  unset PROMPT_GRAY
  unset PROMPT_Black
  unset PROMPT_Dark_Gray
  unset PROMPT_Blue
  unset PROMPT_Light_Blue
  unset PROMPT_Green
  unset PROMPT_Light_Green
  unset PROMPT_Cyan
  unset PROMPT_Light_Cyan
  unset PROMPT_Red
  unset PROMPT_Light_Red
  unset PROMPT_Purple
  unset PROMPT_Light_Purple
  unset PROMPT_Brown
  unset PROMPT_Yellow
  unset PROMPT_Light_Gray
  unset PROMPT_White

  /opt/local/bin/keychain -q id_dsa id_dsa_laptop id_dsa_snow id_rsa
  [[ -z "$HOSTNAME" ]] && HOSTNAME=$(uname -n)

  [[ -f "$HOME/.keychain/$HOSTNAME-sh" ]] && \
     . "$HOME/.keychain/$HOSTNAME-sh"

  [[ -d "$HOME/.keychain/$HOSTNAME-sh-gpg" ]] && \
     . "$HOME/.keychain/$HOSTNAME-sh-gpg" 

fi
