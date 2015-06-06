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
      missing) echo "(!!) $FILENAME missing"; return ;;
      *) ;;
    esac

    echo "$FILENAME" >> "$HOME/.bashrc_configfiles"
    echo "(++) $FILENAME sourced"
}

# some internal variable definitions
# --------------------------------------
if [ $OSNAME == "Linux" ]
then
  OSNAMES[${#OSNAMES[*]}]="Linux"
  if [ -e /etc/redhat-release ]
  then

    OSNAMES[${#OSNAMES[*]}]="RedHat"

    if grep -qi centos /etc/redhat-release
    then
      OSNAMES[${#OSNAMES[*]}]="CentOS"
    fi
  fi

  [[ -e /etc/mandrake-release ]]  && OSNAMES[${#OSNAMES[*]}]="Mandrake"
  [[ -e /etc/SuSE-release ]]      && OSNAMES[${#OSNAMES[*]}]="SuSE"
  [[ -e /etc/fedora-release ]]    && OSNAMES[${#OSNAMES[*]}]="Fedora"
  [[ -e /etc/debian_version   ]]  && OSNAMES[${#OSNAMES[*]}]="Debian"
  [[ -e /etc/wrs-release ]]       && OSNAMES[${#OSNAMES[*]}]="WindRiver"
  [[ -e /etc/snow-release ]]      && OSNAMES[${#OSNAMES[*]}]="Snow"

  LSB_DIST=$(__check_lsb)
  if [ ! -z "$LSB_DIST" ]
  then
    OSNAMES[${#OSNAMES[*]}]="$LSB_DIST"
  fi

else
  OSNAMES[${#OSNAMES[*]}]=$OSNAME
fi

OSNAMES[${#OSNAMES[*]}]=$SHN

__store_debug "$HOME/.bashrc" "yes"

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

