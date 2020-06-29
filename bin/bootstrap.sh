#!/bin/bash
#===============================================================================
#
#         FILE:  bootstrap.sh
#
#        USAGE:  bootstrap.sh
#
#  DESCRIPTION:  setup the bash configuration
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (jvzantvoort), John@vanZantvoort.org
#      COMPANY:  none
#      CREATED:  07-Aug-2017
#===============================================================================

# function print_help {{{
function print_help()
{
    echo "$0 [-h] [-f] [-y]"
    echo 
    echo "  -h show help"
    echo "  -y assume yes"
    echo "  -f force overwrite"
    echo 
}
# }}}

FORCED="no"
ASSUME_YES="no"
UPDATE="yes"

while getopts "fhy" opt; do
  case $opt in
    f) FORCED="yes" ;;
    y) ASSUME_YES="yes" ;;
    h) print_help; exit ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      print_help
      exit 1
      ;;
  esac
done

grep -q '/.bash/bashrc.sh' ~/.bashrc && UPDATE="no"

[[ "$FORCED" = "yes" ]] && UPDATE="yes"

[[ "$UPDATE" = "yes" ]] || exit 0

if [[ "${ASSUME_YES}" = "no" ]]
then
  echo -n "Update .bashrc [yN]: "
  read -r INPUT_VAR
  echo
  INPUT_VAR=$(echo "$INPUT_VAR"|tr '[:lower:]' '[:upper:]')
  if [ ! "${INPUT_VAR}" = "Y" ]
  then
    printf "    abort.\n"
    exit 0
  fi
fi

[[ -e "${HOME}/.bashrc" ]] && rm "${HOME}/.bashrc"
cat > "${HOME}/.bashrc" << 'END'
# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
[[ -f "${HOME}/.bash/bashrc.sh" ]] && . "${HOME}/.bash/bashrc.sh"
END

if [ ! -d "tmux.d/tmux-themepack" ]
then
  pushd tmux.d || exit 1
  git clone https://github.com/jimeh/tmux-themepack.git
  popd || exit 2
fi

# vim: foldmethod=marker
