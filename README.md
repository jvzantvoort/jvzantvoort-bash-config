John van Zantvoort's bash config.

This is my config setup which works best for me.

# Installation

To install the config simply move the old one away (just in case)

    % cd
    % mv .bashrc{,.org}

Checkout the config

    % git clone https://github.com/jvzantvoort/jvzantvoort-vim-config.git .vim

Hard link the vimrc

    % ln .bash/bashrc.sh .bashrc
    % mkdir -p $HOME/bin
    % ln .bash/bin/resume $HOME/bin/resume
