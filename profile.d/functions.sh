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
