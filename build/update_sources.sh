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
readonly C_SCRIPTPATH=$(readlink -f "$0")
readonly C_SCRIPTDIR=$(dirname "$C_SCRIPTPATH")
readonly C_PROJECTDIR=$(dirname "${C_SCRIPTDIR}")
readonly C_LOCALDIR="${HOME}/.bash"
readonly C_FACILITY="local0"

readonly URL_GIT_PROMPT="https://raw.githubusercontent.com/git/git/v2.28.0/contrib/completion/git-prompt.sh"
readonly URL_TMUX_ARCH="https://github.com/jimeh/tmux-themepack.git"

SW_OUTPUT="${C_PROJECTDIR}"
SW_VERBOSE="no"

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
  local RETV="0"
  local TEMPLATE="/tmp/bashrc.XXXXXXXX"

  STAGING_AREA=$(mktemp -d ${TEMPLATE})
  RETV=$?

  [[ $RETV == 0 ]] && return
  script_exit "mkstaging_area failed $RETV" "${RETV}"

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

    logging_info "${string} sourceurl: $source_url"
    logging_info "${string} destdir: $destdir"
    logging_info "${string} basename: $bn"

    mkdir -p "${STAGING_AREA}/src"

    pushd "${STAGING_AREA}/src" || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

    git clone "${source_url}"
    logging_info "tag: $tag"
    [[ -z "${tag}" ]] && tag="latest"



    pushd "$bn" || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

    if [[ "${tag}" == "latest" ]]
    then
      tag=`git describe --tags $(git rev-list --tags --max-count=1)`
    fi

    logging_info "${string} version: $tag"

    mkdir -p "${destdir}"
    git archive --format=tar "${tag}" | tar -xvf - -C "${destdir}"
    logging_info "${string} destdir: ${destdir}"
    printf "Downloaded from %s (version: %s)\n" "${source_url}" "${tag}" \
      > "${destdir}/download.txt"

    popd || \
      script_exit "${string} failed to change to ${STAGING_AREA}/src" 1

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
[[ -z "$STAGING_AREA" ]] && script_exit "STAGING_AREA variable is empty" 1

git_exp_tag "${URL_TMUX_ARCH}" "${STAGING_AREA}/tmux-themepack"

mkdir -p "${SW_OUTPUT}/tmux.d/tmux-themepack/"

rsync -a --delete "${STAGING_AREA}/tmux-themepack/" "${SW_OUTPUT}/tmux.d/tmux-themepack/"

rm -rf "${STAGING_AREA}"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
