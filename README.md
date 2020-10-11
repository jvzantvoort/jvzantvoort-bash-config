John van Zantvoort's bash config.

[github page](https://jvzantvoort.github.io/jvzantvoort-bash-config/)

This is my config setup which works best for me.

# Installation

To install the config simply move the old one away (just in case)

    % cd
    % mv .bashrc{,.org}

Checkout the config

    % git clone https://github.com/jvzantvoort/jvzantvoort-bash-config.git .bash

Hard link the vimrc

    % ln .bash/bashrc.sh .bashrc

Or overwrite/extend the the bashrc with:

```bash
# .bashrc

# Source global definitions
[[ -f /etc/bashrc ]] && . /etc/bashrc

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
[[ -f "${HOME}/.bash/bashrc.sh" ]] && . "${HOME}/.bash/bashrc.sh"
```

