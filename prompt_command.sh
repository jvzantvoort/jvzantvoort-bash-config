#!/bin/bash
[[ "$-" =~ i ]] || return

# Prompt command messes up prompt.
PROMPT_COMMAND='printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
