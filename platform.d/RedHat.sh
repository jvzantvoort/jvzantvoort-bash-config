#!/bin/bash
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

[[ "$-" =~ i ]] || return

function pathmunge()
{
  local dirn="$1"
  [[ -z "${dirn}" ]] && return
  [[ -d "${dirn}" ]] || return

  if echo "$PATH" | grep -E -q "(^|:)$1($|:)"
  then
    return
  fi

  if [[ "$2" = "after" ]]
  then
    PATH=$PATH:$1
  else
    PATH=$1:$PATH
  fi
}

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# update paths
# --------------------------------------
pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge "$HOME/bin" "after"

if [[ -n "${JAVA_HOME}" ]]
then
  pathmunge "${JAVA_HOME}/bin"
fi

export PATH
"$HOME/.bash/bin/cprint" platform RedHat

unset _cleanpath
unset pathmunge
