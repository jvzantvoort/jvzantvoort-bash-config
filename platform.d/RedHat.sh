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

# PATH
# --------------------------------------
# Some path cleaning
PATH=$(echo $PATH|sed -e "s,~,$HOME,g"| tr \: \\n | while read dir; do [[ -d "${dir}" ]] && echo -n ":${dir}"; done | sed 's,^\:,,')

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(lesspipe)"

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

complete -r

[ -x "/usr/bin/vim"  ] || alias vim=vi
[ -x "/usr/bin/gvim" ] || alias gvim=vim
EDITOR=vim
SVN_EDITOR=$EDITOR
alias edit=$EDITOR

# update paths
# --------------------------------------
pathmunge () {
    [ -d "$1" ] || return

    EGREP="/bin/egrep"
    [ -x "/usr/bin/egrep" ] && \
        EGREP=/usr/bin/egrep

    if ! echo $PATH | $EGREP -q "(^|:)$1($|:)"
    then
        if [ "$2" = "after" ]
        then
            PATH=$PATH:$1
        else
            PATH=$1:$PATH
        fi
    fi
}

pathmunge /sbin
pathmunge /usr/sbin
pathmunge /usr/local/sbin
pathmunge $HOME/bin "after"
[[ ! -z $JAVA_HOME ]] && pathmunge "${JAVA_HOME}/bin"

export PATH

tty 1>/dev/null 2>&1 || return
echo -e " \033[0;32m*\033[0m RedHat profile sourced"
