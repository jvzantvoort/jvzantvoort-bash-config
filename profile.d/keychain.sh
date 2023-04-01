#!/bin/bash

[[ "$-" =~ i ]] || return

[[ -x "/usr/bin/keychain" ]] || return

function _list_keys()
{
  find "$HOME/.ssh" -maxdepth 1 -mindepth 1 -type f -name '*.pub'
}

function _list_keynames()
{
  _list_keys | sed 's,.*\/\(.*\).pub,\1,'|sort | tr \\n ' '
}

# make sure the permissions of the keyfiles are c
_list_keys | while read -r keyfile
do
  keyfile=$(basename "$keyfile" .pub)
  filestat=$(stat -c "%a" "$HOME/.ssh/$keyfile")

  if [[ "${filestat}" != "600" ]]
  then
    echo "(--) fix permissions for $keyfile"
    chmod 600 "$HOME/.ssh/$keyfile"

  fi
done

#shellcheck disable=SC2046
/usr/bin/keychain --quiet $(_list_keynames)

if [[ -z "$HOSTNAME" ]]
then
  HOSTNAME="$(hostname -s)"
fi

if [[ -f $HOME/.keychain/$HOSTNAME-sh ]]
then
  #shellcheck disable=SC1090
  source "$HOME/.keychain/$HOSTNAME-sh"
fi

unset _list_keys
unset _list_keynames
