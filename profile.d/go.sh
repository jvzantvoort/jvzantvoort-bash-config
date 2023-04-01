#!/bin/bash

[[ "$-" =~ i ]] || return

[[ -d "/usr/local/go/bin" ]] || return

PATH="/usr/local/go/bin:$PATH"
GOPATH=$(go env GOPATH)
GOBIN="${GOPATH}/bin"

[[ -z "${GOBIN}" ]] || PATH="${PATH}:${GOBIN}"

export PATH GOPATH GOBIN
