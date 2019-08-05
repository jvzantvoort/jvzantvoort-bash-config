#!/bin/bash
#==========================================================================
#
#         FILE:  functions.sh
#
#  DESCRIPTION:  a collection of functions
#
#==========================================================================

[[ "$-" =~ i ]] || return

etime()
{
    perl -MPOSIX -e 'print POSIX::strftime( "%A %B %d %Y %H:%M:%S\n", localtime( shift(@ARGV) ) );' $1
}

function update_home_git()
{
  for target in vim bash tools
  do
    [[ -d "${HOME}/.${target}" ]] || continue
    pushd "${HOME}/.${target}" >/dev/null 2>&1
    git pull --quiet origin master
    popd >/dev/null 2>&1
  done
}

