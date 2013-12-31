#!/bin/bash
#===============================================================================
#
#         FILE:  prompt.sh
#
#  DESCRIPTION:  attempt to create a prompt
#
#===============================================================================

# colors prompts aren't needed on non-
# interactive screens
# --------------------------------------
tty 1>/dev/null 2>&1 || return

# SunOS and colors don't always work
# --------------------------------------
if [ $(uname -s) = "SunOS" ]
then
  PS1="\u@\h \T [\w]
# "
  return
fi
# --------------------------------------
#

if [ -x "$HOME/.bash/bin/gen_prompt" ]
then
    eval $($HOME/.bash/bin/gen_prompt)
fi

