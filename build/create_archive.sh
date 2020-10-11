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

readonly COLOR_RED=$'\e[1;31m'
readonly COLOR_GREEN=$'\e[1;32m'
readonly COLOR_YELLOW=$'\e[1;33m'
readonly COLOR_GREY=$'\e[1;90m'
readonly COLOR_DEFAULT=$'\e[1;39m'

declare ARCH_STAGING_AREA

SW_OUTPUT="${C_PROJECTDIR}"
SW_VERBOSE="no"
SW_NAME="jvzantvoort-bash-config-0"
SW_REF=""

function logc()
{

  local priority="$1"; shift
  local color="$1"; shift
  local message="$@"
  if [[ -n "${ARCH_STAGING_AREA}" ]]
  then
    message=$(echo "${message}" | sed "s,${ARCH_STAGING_AREA},ARCH_STAGING_AREA,g")
  fi
  printf "%s %s %7s %s\e[0m\n" "$color" "${C_SCRIPTNAME}" "${priority}" "$message"
}

function log_err()     { logc "err"     "${COLOR_RED}"    "$@"; }
function log_debug()   { logc "debug"   "${COLOR_GREY}"   "$@"; }
function log_info()    { logc "info"    "${COLOR_GREEN}"  "$@"; }
function log_warn()    { logc "warn"    "${COLOR_YELLOW}" "$@"; }
function log_success() { logc "success" "${COLOR_GREEN}"  "$@"; }
function log_failure() { logc "failure" "${COLOR_RED}"    "$@"; }
function log_pushd()   { logc "debug"   "${COLOR_GREY}"   "pushd $1"; }

function script_exit()
{
  local string="$1"
  local retv="${2:-0}"
  if [ "$retv" = "0" ]
  then
    log_success "$string"
  else
    log_failure "$string"
  fi
  exit "$retv"
}

function exec_status()
{
  local exitcode="$1"; shift
  if [[ "${exitcode}" == "0" ]]
  then
    log_success "$@"
  else
    log_failure "$@"
  fi
}

function exec_minor_status()
{
  local exitcode="$1"; shift
  if [[ "${exitcode}" == "0" ]]
  then
    log_debug "$@"
  else
    log_failure "$@"
  fi
}

function usage()
{
  printf "%s [-h] [-o <filepath>]\n" "${C_SCRIPTPATH}"
  exit 0
}

function mkstaging_area()
{
  local template
  local retv
  local tmp

  tmp="${TMPDIR:-/tmp}"
  template="${tmp}/${C_SCRIPTNAME}.XXXXXXXX"
  retv="0"

  ARCH_STAGING_AREA=$(mktemp -d ${template})
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
    log_debug "Create directory ${dst}/${targetdir}"
    mkdir -p "${dst}/${targetdir}"
  fi

  echo "${target}" | grep -q -E "(bin|build)\/"
  retv=$?
  [[ "${retv}" == "0" ]] && mode="755"

  install -m "${mode}" "${src}/${target}" "${dst}/${target}"
  exec_minor_status "$?" "install ${target}"

}

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

# parse command line arguments:
while getopts hn:o:r:v option; do
  case ${option} in
    h) usage ;;
    o) SW_OUTPUT=$OPTARG ;;
    n) SW_NAME=$OPTARG ;;
    v) SW_VERBOSE="yes" ;;
    ?) exit 1;;
  esac
done

SW_OUTPUT=$(readlink -f "${SW_OUTPUT}")

if [[ -n "${SW_REF}" ]]
then
  SW_NAME=$(echo "${SW_REF}" | sed 's,.*/,,')
fi

log_info "NAME: ${SW_NAME}"
log_info "OUTPUT: ${SW_OUTPUT}"
log_info "VERBOSE: ${SW_VERBOSE}"

if [[ "${SW_VERBOSE}" == "yes" ]]
then
  set -xv
fi

#
# Add the tmux-themepack
#
mkstaging_area || script_exit "mkstaging_area failed" 1
[[ -z "$ARCH_STAGING_AREA" ]] && script_exit "ARCH_STAGING_AREA variable is empty" 1

find "${C_PROJECTDIR}" -mindepth 1 -type d -not -path "*/.git/*" -not -name '.git' | \
  sed "s,$C_PROJECTDIR\/,," | while read -r targetdir
  do
    find "${C_PROJECTDIR}/${targetdir}" -maxdepth 1 -mindepth 1 -type f | \
      sed "s,$C_PROJECTDIR\/,," | while read -r targetfile
      do
        install_target "${C_PROJECTDIR}" "${ARCH_STAGING_AREA}/${SW_NAME}" "${targetfile}"
      done
  done

log_info "${C_SCRIPTDIR}/update_sources.sh -o ${SW_OUTPUT}"
"${C_SCRIPTDIR}/update_sources.sh" -o "${SW_OUTPUT}"
exec_status "$?" "update sources"

log_pushd "${ARCH_STAGING_AREA}"
pushd "${ARCH_STAGING_AREA}" 1>/dev/null 2>&1 || script_exit "cannot push"
tar -zcf "${SW_OUTPUT}/${SW_NAME}.tar.gz" "${SW_NAME}"
exec_status $? "Create tarfile: ${SW_OUTPUT}/${SW_NAME}.tar.gz"
popd >/dev/null 2>&1 || script_exit "cannot pop"

#
# The End
#

rm -rf "${ARCH_STAGING_AREA}"

tar -ztf "${SW_OUTPUT}/${SW_NAME}.tar.gz" | grep -q "tmux-themepack"
RETV=$?

exec_status "${RETV}" "Check sources for downloaded sources"

exit "${RETV}"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
