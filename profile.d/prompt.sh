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
[[ "$-" =~ i ]] || return

[[ -x "$HOME/.bash/bin/gen_prompt" ]] || return

eval $("$HOME/.bash/bin/gen_prompt")
