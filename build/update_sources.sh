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

readonly URL_GIT_PROMPT="https://raw.githubusercontent.com/git/git/v2.28.0/contrib/completion/git-prompt.sh"
#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

curl --insecure --location --output "${C_PROJECTDIR}/profile.d/git-prompt.sh" "${URL_GIT_PROMPT}"

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
