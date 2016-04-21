#!/bin/sh

[ -x /usr/bin/pass ] || return

[ -r /etc/bash_completion.d/password-store ] || return

source /etc/bash_completion.d/password-store
