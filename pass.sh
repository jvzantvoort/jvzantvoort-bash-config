#!/bin/bash

[[ "$-" =~ i ]] || return

[[ -x /usr/bin/pass ]] || return

[[ -r /etc/bash_completion.d/password-store ]] || return

#shellcheck disable=SC1091
source /etc/bash_completion.d/password-store
