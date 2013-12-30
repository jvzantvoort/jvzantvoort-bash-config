#!/bin/bash
#===============================================================================
#
#         FILE:  SunOS.sh
#
#  DESCRIPTION:  SunOS specific settings
#
#===============================================================================

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# some local variable definitions
# --------------------------------------
HISTCONTROL=ignoredups
HISTSIZE=1000
SVN_EDITOR=vim
EDITOR=vim

# PATH
# --------------------------------------
# Some path cleaning
PATH=$(echo $PATH | sed 's/\:\.\:/\:/g')

export SVN_EDITOR LS_COLORS PATH

PS1="\u@\h \T [\w]
# "

