#!/bin/sh
/usr/bin/keychain --quiet id_dsa id_dsa_bertha id_dsa_upload id_rsa id_rsa_snow
[ -z "$HOSTNAME" ] && HOSTNAME=‘uname -n‘
[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh
