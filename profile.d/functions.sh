#!/bin/bash
[[ "$-" =~ i ]] || return

function etime()
{
    perl -MPOSIX -e 'print POSIX::strftime( "%A %B %d %Y %H:%M:%S\n", localtime( shift(@ARGV) ) );' "$@"
}
