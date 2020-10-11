#!/bin/bash
#===============================================================================
#
#         FILE:  create_archive.sh
#
#        USAGE:  create_archive.sh
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  jvzantvoort (John van Zantvoort), john@vanzantvoort.org
#      COMPANY:  JDC
#      CREATED:  2020-10-11
#
# Copyright (C) 2020 John van Zantvoort
#
#===============================================================================
readonly C_SCRIPTPATH=$(readlink -f "$0")
readonly C_SCRIPTDIR=$(dirname "$C_SCRIPTPATH") # the build dir
readonly C_PROJECTDIR=$(dirname "${C_SCRIPTDIR}")
readonly C_SCRIPTNAME=$(basename "$C_SCRIPTPATH" .sh)
readonly C_FACILITY="local0"


SW_OUTPUT="${C_PROJECTDIR}"
SW_VERBOSE="no"
SW_NAME="jvzantvoort-bash-config-0"

function logging()
{
  local priority="$1"; shift
  #shellcheck disable=SC2145
  logger -p "${C_FACILITY}.${priority}" -i -s \
    -t "${C_SCRIPTNAME}" -- "${priority} $@"
}

function logging_err() {  logging "err" "$@";  }
function logging_info() { logging "info" "$@"; }

function script_exit()
{
  local string="$1"
  local retv="${2:-0}"
  if [ "$retv" = "0" ]
  then
    logging_info "$string"
  else
    logging_err "$string"
  fi
  exit "$retv"
}


function usage()
{
  printf "%s [-h] [-o <filepath>]\n" "${C_SCRIPTPATH}"
  exit 0
}

function curl_download()
{
  local dst="$1"
  local src="$2"
  local silent
  if [[ "${SW_VERBOSE}" == "yes" ]]
  then
    silent=""
  else
    silent="--silent"
  fi

  curl --insecure --location ${silent} --output "${SW_OUTPUT}/profile.d/git-prompt.sh" "${URL_GIT_PROMPT}"

}

function mkstaging_area()
{
  local template
  local retv

  template="/tmp/${C_SCRIPTNAME}.XXXXXXXX"
  retv="0"

  STAGING_AREA=$(mktemp -d ${template})
  retv=$?

  [[ $retv == 0 ]] || script_exit "mkstaging_area failed $retv" "${retv}"

} # end: mkstaging_area

function install_target()
{
  local src="$1" # sourcedir
  local dst="$2" # destdir
  local target="$3"
  local mode

  target=$(echo "${target}" | sed "s,${src}\/,,")
  targetdir=$(dirname "${target}")
  mode="644"

  if [[ ! -d "${dst}/${targetdir}" ]]
  then
    mkdir -p "${dst}/${targetdir}"
  fi

  echo "${target}" | grep -q -E "(bin|build)\/"
  retv=$?
  [[ "${retv}" == "0" ]] && mode="755"

  install -m "${mode}" "${src}/${target}" "${dst}/${target}"

}

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

# parse command line arguments:
while getopts hn:o:v option; do
  case ${option} in
    h) usage ;;
    o) SW_OUTPUT=$OPTARG ;;
    n) SW_NAME=$OPTARG ;;
    v) SW_VERBOSE="yes" ;;
    ?) exit 1;;
  esac
done

SW_OUTPUT=$(readlink -f "${SW_OUTPUT}")


if [[ "${SW_VERBOSE}" == "yes" ]]
then
  set -xv
fi

#
# Add the tmux-themepack
#
mkstaging_area || script_exit "mkstaging_area failed" 1
[[ -z "$STAGING_AREA" ]] && script_exit "STAGING_AREA variable is empty" 1

find "${C_PROJECTDIR}" -mindepth 1 -type d -not -path "*/.git/*" -not -name '.git' | \
  sed "s,$C_PROJECTDIR\/,," | while read -r targetdir
  do
    find "${C_PROJECTDIR}/${targetdir}" -maxdepth 1 -mindepth 1 -type f | \
      sed "s,$C_PROJECTDIR\/,," | while read -r targetfile
      do
        install_target "${C_PROJECTDIR}" "${STAGING_AREA}/${SW_NAME}" "${targetfile}"
      done
  done

"${C_SCRIPTDIR}/update_sources.sh" -o "${SW_OUTPUT}" -v

pushd "${STAGING_AREA}" 1>/dev/null 2>&1 || script_exit "cannot push"
tar -zcf "${SW_OUTPUT}/${SW_NAME}.tar.gz" "${SW_NAME}"
popd  1>/dev/null 2>&1 || script_exit "cannot push"

#
# The End
#

rm -rf "${STAGING_AREA}"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
