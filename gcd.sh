#!/bin/bash

[[ "$-" =~ i ]] || return

function gcd()
{
  local root
  root="$(git rev-parse --show-toplevel)"
  if [[ -n "${root}" ]]
  then
    cd $root/$1
  else
    cd $1
  fi
}
