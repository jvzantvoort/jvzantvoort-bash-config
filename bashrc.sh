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


# Source global definitions
# --------------------------------------
if [ -f /etc/bashrc ]; then
  . /etc/bashrc
fi

HISTCONTROL=ignoredups
OSNAME=$(uname -s)
SHN=$(uname -n | cut -d\. -f 1)

__check_lsb()
{
  LSB_DIST=$(which lsb_release 2>/dev/null)
  [ -z "$LSB_DIST" ] && return
  $LSB_DIST -is
}

__store_debug()
{
    FILENAME=$1
    ACTION=$2
    [[ -f "$HOME/.bash/debug" ]] || return

    case $ACTION in
      cleanup) rm "$HOME/.bashrc_configfiles" ;;
      missing) ${HOME}/.bash/bin/cprint nok "$FILENAME missing"; return ;;
      *) ;;
    esac

    echo "$FILENAME" >> "$HOME/.bashrc_configfiles"
    ${HOME}/.bash/bin/cprint debug "$FILENAME sourced"
}

function __in()
{
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

# some internal variable definitions
# --------------------------------------
if [ $OSNAME == "Linux" ]
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
  if [ ! -z "$LSB_DIST" ]
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

for i in $HOME/.bash/profile.d/*.sh
do
    if [ -r "$i" ]
    then
        __store_debug "$i"

        if [ "${-#*i}" != "$-" ]; then
            . $i
        else
            . $i >/dev/null 2>&1
        fi
    fi
done
${HOME}/.bash/bin/cprint profile "common"

for osname in $(seq 0 $((${#OSNAMES[@]} - 1)))
do
  FILENAME="${HOME}/.bash/platform.d/${OSNAMES[$osname]}.sh"
  if [ -f "${FILENAME}" ]
  then
    __store_debug "$FILENAME"
    . $FILENAME
  else
    __store_debug "$FILENAME" "missing"
  fi
done

unset __check_lsb
unset __store_debug
unset __in

