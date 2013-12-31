#===============================================================================
#
#         FILE:  .bashrc.Darwin
#
#  DESCRIPTION:  local bash configuration
#
#      OPTIONS:  ---
# REQUIREMENTS:  ---
#         BUGS:  ---
#        NOTES:  ---
#       AUTHOR:  John van Zantvoort (JvZ), <john.van.zantvoort@snow.nl>
#      CREATED:  
#     REVISION:  $Revision: 1.6 $
#===============================================================================

LC_ALL=en_US.UTF-8
LC_CTYPE=UTF-8
LANG=en_US.UTF-8
export LC_ALL LC_CTYPE LANG

VIMAPPLPATH="/Applications/MacPorts/MacVim.app/Contents/MacOS"
PATH="/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/opt/X11/bin:/usr/texbin"

# update paths
# --------------------------------------
pathmunge () {
    if [ ! -d "$1" ]
    then
      return
    fi

    EGREP="/bin/egrep"
    if [ -x "/usr/bin/egrep" ]
    then
      EGREP=/usr/bin/egrep
    fi

    if ! echo $PATH | $EGREP -q "(^|:)$1($|:)" ; then
        if [ "$2" = "after" ] ; then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

pathmunge "/opt/local/bin"
pathmunge "/opt/local/sbin"
pathmunge "$HOME/bin" "after"

[ -f "$HOME/.netw" ] && . $HOME/.netw

if [ -x "$VIMAPPLPATH/Vim" ]
then
  pathmunge "$VIMAPPLPATH"
  alias vim=Vim
  alias gvim='Vim -g'
  alias edit='open -a MacVim'
fi

EDITOR=vim
SVN_EDITOR=$EDITOR
export PATH EDITOR SVN_EDITOR

# some local variable definitions
# --------------------------------------
MYHOST=`uname -n | sed 's!\..*$!!'`

