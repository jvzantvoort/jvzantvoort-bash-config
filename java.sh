#!/bin/bash

[[ "$-" =~ i ]] || return

[[ -z "${JAVA_HOME}" ]] && return

[[ -d "${JAVA_HOME}/bin" ]] || return


if echo "$PATH" | grep -E -q "(^|:)${JAVA_HOME}/bin($|:)"
then
  PATH="${JAVA_HOME}/bin:$PATH"
fi

export PATH
