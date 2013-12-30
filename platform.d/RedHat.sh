#===============================================================================
#
#         FILE:  ~/.bashrc
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


# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

complete -r

SESSIONNAME=

EDITOR=vi

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

etime() {
    /usr/bin/perl -MPOSIX -e 'print POSIX::strftime( "%A %B %d %Y %H:%M:%S\n", localtime( shift(@ARGV) ) );' $1
}

bcd()
{
  if [ -z "${WORKSPACE}" ]
  then
    cd ${HOME}/$*
  else
    cd "${WORKSPACE}/$*"
  fi
}
# PATH
# --------------------------------------
# Some path cleaning
PATH=$(echo $PATH|sed -e "s,~,$HOME,g"| tr \: \\n | while read dir; do [[ -d "${dir}" ]] && echo -n ":${dir}"; done | sed 's,^\:,,')

pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge $HOME/bin "after"
pathmunge /Applications/MacPorts/MacVim.app/Contents/MacOS
pathmunge $HOME/appl/texlive/bin/i386-linux "after"
[[ ! -z $JAVA_HOME ]] && pathmunge "${JAVA_HOME}/bin"

export PATH
# some internal variable definitions
# --------------------------------------
OS=$(uname -s)
if [ -e /etc/redhat-release ]
then
        if grep -qi centos /etc/redhat-release
        then
                OS="centos"
        else
                OS="redhat"
        fi
fi
[[ -e /etc/snow-release ]]      && OS="snow"
[[ -e /etc/mandrake-release ]]  && OS="mandrake"
[[ -e /etc/SuSE-release ]]      && OS="suse"
[[ -e /etc/fedora-release ]]    && OS="fedora"
[[ -e /etc/debian_version   ]]  && OS="debian"

    if [ -x "/usr/bin/vim" ]
    then
      alias vim=/usr/bin/vim

    else
      alias vim=vi

    fi

    if [ -x "/usr/bin/gvim" ]
    then
      alias gvim=/usr/bin/gvim
    else
      alias gvim=vim
    fi

    EDITOR=vim

    alias edit=$EDITOR

# some local variable definitions
# --------------------------------------
SVN_EDITOR=$EDITOR
MYHOST=`uname -n | sed 's!\..*$!!'`
TTY_NAME=

# Set the perty prompt colors
# --------------------------------------
if tty 1>/dev/null 2>&1
then

  export TTY_NAME=`tty`
  if [ -f "${HOME}/.aliasses" ]
  then
    [[ -f "$HOME/.bashrc_configfiles" ]] && \
      echo "$HOME/.aliasses" >> "$HOME/.bashrc_configfiles"
    . ${HOME}/.aliasses
  else
    alias ll='/bin/ls -lA'
  fi

  SHN=$(uname -n | cut -d\. -f 1)
  PROMPT_Cyan='\[\033[0;36m\]'
  PROMPT_END='\[\033[0m\]'
  PROMPT_Yellow='\[\033[1;33m\]'

  if [ -z "$SESSIONNAME" ]
  then
    PS1="\[\033[0;32m\]\u@\h\[\033[0m\]/\[\033[0;36m\]centos\[\033[0m\] \T [\[\033[1;36m\]\w\[\033[0m\]]
# "
  else
    PS1="\[\033[0;32m\]\u@\h\[\033[0m\]/\[\033[0;36m\]centos\[\033[0m\] ${PROMPT_Yellow}${SESSIONNAME}${PROMPT_END} \T [\[\033[1;36m\]\w\[\033[0m\]]
# "
  fi

  PROMPT_COMMAND='echo -ne "\033]0;${OS}/${MYHOST}\007"'

fi
[ -z "$TTY_NAME" ] || echo -e " \033[0;32m*\033[0m RedHat profile sourced"
