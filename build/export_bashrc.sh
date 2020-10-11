#!/bin/bash
#===============================================================================
#
#         FILE:  export_bashrc.SH
#
#        USAGE:  export_bashrc.SH
#
#  DESCRIPTION:  
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  jvzantvoort (John van Zantvoort), john@vanzantvoort.org
#      COMPANY:  JDC
#      CREATED:  2020-05-29
#
# Copyright (C) 2020 John van Zantvoort
#
#===============================================================================
readonly C_SCRIPTPATH=$(readlink -f "$0")
readonly C_SCRIPTNAME=$(basename "$C_SCRIPTPATH" .sh)
readonly C_FACILITY="local0"
declare -xr LANG="C"

function logging()
{
  local priority="$1"; shift
  #shellcheck disable=SC2145
  logger -p "${C_FACILITY}.${priority}" -i -s \
    -t "${C_SCRIPTNAME}" -- "${priority} $@"
}

function logging_err() {  logging "err" "$@";  }
function logging_info() { logging "info" "$@"; }
function git_url() { git config --get remote.origin.url; }

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

function mkstaging_area()
{
  local RETV="0"
  local TEMPLATE="/tmp/bashrc.XXXXXXXX"

  STAGING_AREA=$(mktemp -d ${TEMPLATE})
  RETV=$?

  [[ $RETV == 0 ]] && return
  script_exit "mkstaging_area failed $RETV" "${RETV}"

} # end: mkstaging_area


git_exp()
{
    local source_url=$1
    local destdir=$2
    local bn
    local string
    bn=$(basename "${source_url}" .git)
    string="export ${bn}"

    logging_info "${string} sourceurl: $source_url"
    logging_info "${string} destdir: $destdir"
    logging_info "${string} basename: $bn"

    mkdir -p "${STAGING_AREA}/src"

    pushd "${STAGING_AREA}/src" || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

    git clone "${source_url}"

    mkdir -p "${destdir}"

    pushd "$bn" || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

    git archive --format=tar HEAD | tar -xvf - -C "${destdir}"

    popd || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

} # end: git_exp

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

TIMESTAMP=$(date +%Y%m%d%H%M%S)
OUTPUTDIR="bashconfig_${TIMESTAMP}"
logging_info "create staging area"
mkstaging_area || script_exit "mkstaging_area failed" 1
[[ -z "$STAGING_AREA" ]] && script_exit "STAGING_AREA variable is empty" 1

mkdir -p "${STAGING_AREA}/src" || script_exit "cannot create src dir" 1
mkdir -p "${STAGING_AREA}/${OUTPUTDIR}/.bash" || script_exit "autoload dir not created" 1

git_exp "$(git_url)" "${STAGING_AREA}/$OUTPUTDIR/.bash"

pushd "${STAGING_AREA}" >/dev/null 2>&1 || script_exit "failed to enter staging" 1

tar -jvcf "${HOME}/${OUTPUTDIR}.tar.bz2" "${OUTPUTDIR}"
popd >/dev/null 2>&1 || script_exit "failed to enter staging" 1
rm -rf "${STAGING_AREA}"
#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
