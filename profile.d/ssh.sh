#!/bin/bash
#===============================================================================
#
#         FILE:  ssh.sh
#
#  DESCRIPTION:  some helper functions for the secure shell client
#
#===============================================================================

_ssh_completion()
{
    perl -ne 'print "$1 " if /^Host (.+)$/' ~/.ssh/config
}

complete -W "$(_ssh_completion)" ssh 
