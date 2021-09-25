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
#       AUTHOR:  John van Zantvoort (jvzantvoort), <john@vanzantvoort.org>
#===============================================================================


# Source global definitions
# --------------------------------------
#shellcheck disable=SC1091
if [[ -f "/etc/bashrc" ]]
then
  source "/etc/bashrc"
fi

HISTCONTROL=ignoredups
OSNAME=$(uname -s)

function __check_lsb()
{
  LSB_DIST=$(which lsb_release 2>/dev/null)
  [ -z "$LSB_DIST" ] && return
  $LSB_DIST -is
}

function __store_debug()
{
    FILENAME=$1
    ACTION=$2
    [[ -f "$HOME/.bash/debug" ]] || return

    case $ACTION in
      cleanup) rm "$HOME/.bashrc_configfiles" ;;
      missing) "${HOME}/.bash/bin/cprint" nok "$FILENAME missing"; return ;;
      *) ;;
    esac

    echo "$FILENAME" >> "$HOME/.bashrc_configfiles"
    "${HOME}/.bash/bin/cprint" debug "$FILENAME sourced"
}

function __in()
{
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

# some internal variable definitions
# --------------------------------------
if [[ "$OSNAME" == "Linux" ]]
then
  OSNAMES[${#OSNAMES[*]}]="Linux"
  [[ -e /etc/redhat-release ]]    && OSNAMES[${#OSNAMES[*]}]="RedHat"
  [[ -e /etc/mandrake-release ]]  && OSNAMES[${#OSNAMES[*]}]="Mandrake"
  [[ -e /etc/SuSE-release ]]      && OSNAMES[${#OSNAMES[*]}]="SuSE"
  [[ -e /etc/fedora-release ]]    && OSNAMES[${#OSNAMES[*]}]="Fedora"
  [[ -e /etc/debian_version   ]]  && OSNAMES[${#OSNAMES[*]}]="Debian"
  [[ -e /etc/wrs-release ]]       && OSNAMES[${#OSNAMES[*]}]="WindRiver"
  [[ -e /etc/snow-release ]]      && OSNAMES[${#OSNAMES[*]}]="Snow"

  if __in "RedHat" "${OSNAMES[@]}"
  then
    if [ -f "/etc/centos-release" ]
    then
      OSNAMES[${#OSNAMES[*]}]="CentOS"
    elif grep -qi centos /etc/redhat-release
    then
      OSNAMES[${#OSNAMES[*]}]="CentOS"
    fi
  fi

  LSB_DIST=$(__check_lsb)
  if [ -n "$LSB_DIST" ]
  then
    if ! __in "$LSB_DIST" "${OSNAMES[@]}"
    then
      OSNAMES[${#OSNAMES[*]}]="$LSB_DIST"
    fi
  fi

else
  OSNAMES[${#OSNAMES[*]}]=$OSNAME
fi

__store_debug "$HOME/.bashrc" "yes"

# print the motd in new screen sessions
[[ -z "${STY}" ]] || cat /etc/motd

while read -r target
do
    if [ -r "$target" ]
    then
        __store_debug "$target"

        if [ "${-#*i}" != "$-" ]; then
            #shellcheck disable=SC1090
            source "$target"
        else
            #shellcheck disable=SC1090
            source "$target" >/dev/null 2>&1
        fi
    fi
done < <(find "$HOME/.bash/profile.d" -maxdepth 1 -mindepth 1 -type f -name "*.sh"|sort)

# allow for local overrides
while read -r target
do
    if [ -r "$target" ]
    then
        __store_debug "$target"

        if [ "${-#*i}" != "$-" ]; then
            #shellcheck disable=SC1090
            source "$target"
        else
            #shellcheck disable=SC1090
            source "$target" >/dev/null 2>&1
        fi
    fi
done < <(find "$HOME/.bash/local.d" -maxdepth 1 -mindepth 1 -type f -name "*.sh"|sort)

if [[ "$-" =~ i ]]
then
"${HOME}/.bash/bin/cprint" profile "common"
fi

for osname in $(seq 0 $((${#OSNAMES[@]} - 1)))
do
  FILENAME="${HOME}/.bash/platform.d/${OSNAMES[$osname]}.sh"
  if [ -f "${FILENAME}" ]
  then
    __store_debug "$FILENAME"
    #shellcheck disable=SC1090
    source "$FILENAME"
  else
    __store_debug "$FILENAME" "missing"
  fi
done

unset __check_lsb
unset __store_debug
unset __in

# Prompt command messes up prompt.
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'

