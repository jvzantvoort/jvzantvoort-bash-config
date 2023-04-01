#!/bin/bash
#===============================================================================
#
#         FILE:  update_sources.sh
#
#        USAGE:  update_sources.sh
#
#  DESCRIPTION:  download external sources to include
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
C_SCRIPTPATH=$(readlink -f "$0")
C_SCRIPTDIR=$(dirname "$C_SCRIPTPATH")
C_PROJECTDIR=$(dirname "${C_SCRIPTDIR}")
C_SCRIPTNAME=$(basename "$C_SCRIPTPATH" .sh)

COLOR_RED=$'\e[1;31m'
COLOR_GREEN=$'\e[1;32m'
COLOR_YELLOW=$'\e[1;33m'
COLOR_GREY=$'\e[1;90m'

URL_GIT_PROMPT="https://raw.githubusercontent.com/git/git/v2.28.0/contrib/completion/git-prompt.sh"
URL_TMUX_ARCH="https://github.com/jimeh/tmux-themepack.git"

readonly C_SCRIPTPATH
readonly C_SCRIPTDIR
readonly C_PROJECTDIR
readonly C_SCRIPTNAME

readonly COLOR_RED
readonly COLOR_GREEN
readonly COLOR_YELLOW
readonly COLOR_GREY

readonly URL_GIT_PROMPT="https://raw.githubusercontent.com/git/git/v2.28.0/contrib/completion/git-prompt.sh"
readonly URL_TMUX_ARCH="https://github.com/jimeh/tmux-themepack.git"


declare  UPD_STAGING_AREA

SW_OUTPUT="${C_PROJECTDIR}"
SW_VERBOSE="no"

function logc()
{

  local priority="$1"; shift
  local color="$1"; shift
  local message="$*"
  if [[ -n "${UPD_STAGING_AREA}" ]]
  then
    message="${message/${UPD_STAGING_AREA}/UPD_STAGING_AREA}"
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

function git_url() { git config --get remote.origin.url; }

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

function usage()
{
  printf "%s [-h] [-o <filepath>]\n" "${C_SCRIPTPATH}"
  exit 0
}

function curl_download()
{
  local src="$1"
  local dst="$2"
  local silent
  if [[ "${SW_VERBOSE}" == "yes" ]]
  then
    silent=""
  else
    silent="--silent"
  fi

  curl --insecure --location ${silent} --output "${dst}" "${src}"
  exec_status "$?" "download ${src} to ${dst}"

}

function mkstaging_area()
{
  local template
  local retv
  local tmp

  tmp="${TMPDIR:-/tmp}"
  template="${tmp}/${C_SCRIPTNAME}.XXXXXXXX"
  retv="0"

  UPD_STAGING_AREA="$(mktemp -d "${template}")"
  retv=$?

  [[ $retv == 0 ]] || script_exit "mkstaging_area failed $retv" "${retv}"

} # end: mkstaging_area


git_exp_tag()
{
  local source_url=$1
  local destdir=$2
  local tag=$3
  local bn
  local string
  bn=$(basename "${source_url}" .git)
  string="export ${bn}"

  log_debug "${string} sourceurl: $source_url"
  log_debug "${string} destdir: $destdir"
  log_debug "${string} basename: $bn"

  mkdir -p "${UPD_STAGING_AREA}/src"

  log_pushd "${UPD_STAGING_AREA}/src"
  pushd "${UPD_STAGING_AREA}/src" >/dev/null 2>&1 || \
    script_exit "${string} failed to change to ${UPD_STAGING_AREA}/src" 1

  git clone "${source_url}"
  exec_status "$?" "clone ${source_url}"

  if [[ -z "${tag}" ]]
  then
    log_debug "tag: empty, defaulting to latest"
    tag="latest"
  else
    log_debug "tag: ${tag}"
  fi

  log_pushd "$bn"
  pushd "$bn" >/dev/null 2>&1 || \
    script_exit "${string} failed to change to ${bn}" 1

  if [[ "${tag}" == "latest" ]]
  then
    tag="$(git describe --tags "$(git rev-list --tags --max-count=1)")"
  fi

  log_debug "${string} version: $tag"

  mkdir -p "${destdir}"
  git archive --format=tar "${tag}" | tar -xf - -C "${destdir}"
  exec_status "$?" "archive ${tag} to ${destdir}"

  printf "Downloaded from %s (version: %s)\n" "${source_url}" "${tag}" \
    > "${destdir}/download.txt"

  popd >/dev/null 2>&1 || \
    script_exit "${string} failed to change to ${UPD_STAGING_AREA}/src" 1

} # end: git_exp


#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

# parse command line arguments:
while getopts ho:v option; do
  case ${option} in
    h) usage ;;
    o) SW_OUTPUT=$OPTARG; ;;
    v) SW_VERBOSE="yes" ;;
    ?) exit 1;;
  esac
done

SW_OUTPUT=$(readlink -f "${SW_OUTPUT}")

log_info "OUTPUT: ${SW_OUTPUT}"
log_info "VERBOSE: ${SW_VERBOSE}"

if [[ "${SW_VERBOSE}" == "yes" ]]
then
  set -xv
fi

#
# Add the git prompt
#
mkdir -p "${SW_OUTPUT}/profile.d"

curl_download "${URL_GIT_PROMPT}" "${SW_OUTPUT}/profile.d/git-prompt.sh"

#
# Add the tmux-themepack
#
mkstaging_area || script_exit "mkstaging_area failed" 1
[[ -z "$UPD_STAGING_AREA" ]] && script_exit "UPD_STAGING_AREA variable is empty" 1

git_exp_tag "${URL_TMUX_ARCH}" "${UPD_STAGING_AREA}/tmux-themepack"

mkdir -p "${SW_OUTPUT}/tmux.d/tmux-themepack/"

rsync -av "${UPD_STAGING_AREA}/tmux-themepack/" "${SW_OUTPUT}/tmux.d/tmux-themepack/"
exec_status "$?" "rsync ${UPD_STAGING_AREA}/tmux-themepack/ ${SW_OUTPUT}/tmux.d/tmux-themepack/"

rm -rf "${UPD_STAGING_AREA}"
exec_status "$?" "Cleanup ${UPD_STAGING_AREA}"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
