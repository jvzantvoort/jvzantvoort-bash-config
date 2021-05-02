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

function _cleanpath()
{
  echo "$PATH" | sed -e "s,~,$HOME,g" | tr : \\n | while read -r dir
  do
    [[ -d "${dir}" ]] && echo -n ":${dir}"
  done | sed 's,^\:,,'
}

function pathmunge()
{
  local dirn="$1"; shift
  if [[ ! -d "${dirn}" ]]
  then
    return
  fi

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

PATH=$(_cleanpath)

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
