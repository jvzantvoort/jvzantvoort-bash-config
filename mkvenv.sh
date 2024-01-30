#!/bin/bash
#===============================================================================
#
#         FILE:  mkvenv
#
#        USAGE:  mkvenv
#
#  DESCRIPTION:  Bash script
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  jvzantvoort (John van Zantvoort), john@vanzantvoort.org
#      COMPANY:  JDC
#      CREATED:  2024-01-30
#
# Copyright (C) 2024 John van Zantvoort
#
#===============================================================================

[[ "$-" =~ i ]] || return

#------------------------------------------------------------------------------#
#                                    Main                                      #
#------------------------------------------------------------------------------#

function mkvenv()
{
  local topdir
  local venvdir
  local name

  if [[ -n "${VIRTUAL_ENV}" ]]
  then
    printf "Already in a virtual env!\n"
    return 1
  fi

  topdir="$(git rev-parse --show-toplevel)"
  if [[ -z "${topdir}" ]]
  then
    printf "No GIT archive\n"
    return 2
  fi
  name="$(basename "${topdir}")"
  venvdir="${topdir}/.venv"

  if [[ ! -e "${venvdir}/bin/activate" ]]
  then
    python -m venv --system-site-packages --prompt "${name}" "${venvdir}"
  fi
  source "${venvdir}/bin/activate"
}

#------------------------------------------------------------------------------#
#                                  The End                                     #
#------------------------------------------------------------------------------#
