#!/bin/sh

[[ "$-" =~ i ]] || return

[ -x /usr/bin/keychain ] || return

# make sure the permissions of the keyfiles are c
ls -1d $HOME/.ssh/*.pub|while read keyfile
do
  keyfile=$(basename $keyfile .pub)
  if [ ! "$(stat -c "%a" "$HOME/.ssh/$keyfile")" = "600" ]
  then
    echo "(--) fix permissions for $keyfile"
    chmod 600 "$HOME/.ssh/$keyfile"
  fi
done

/usr/bin/keychain --quiet $(ls -1d $HOME/.ssh/*.pub | sed 's,.*\/\(.*\).pub,\1,'|sort | tr \\n ' ')

[ -z "$HOSTNAME" ] && HOSTNAME=$(uname -n)

[ -f $HOME/.keychain/$HOSTNAME-sh ] && . $HOME/.keychain/$HOSTNAME-sh
