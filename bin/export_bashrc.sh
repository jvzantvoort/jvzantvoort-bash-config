#!/bin/bash
#===============================================================================
#
#         FILE:  export_bashrc.sh
#
#  DESCRIPTION:  Export the bash setup. For restricted locations.
#
#===============================================================================

# --------------------------------------
# VARIABLES
# --------------------------------------
APPNAME="$(basename $0)"

#===  FUNCTION  ================================================================
#         NAME:  remark
#  DESCRIPTION:  simple function for printing information.
#        NOTES:  make sure you define APPNAME="$(basename $0)" for example like
#                this:
#
#                  APPNAME="$(basename $0)"
#
#   PARAMETERS:  none
#      RETURNS:  0, oke
#                1, not oke
#===============================================================================
remark() {
  if /usr/bin/tty >/dev/null 2>&1
  then
    logger -is -t $APPNAME "$@"
  else
    logger -i -t $APPNAME "$@"
  fi
  return 0
} # end: remark

#===  FUNCTION  ================================================================
#         NAME:  die
#  DESCRIPTION:  shell version of the perl die
#   PARAMETERS:  none
#      RETURNS:  0, oke
#                1, not oke
#===============================================================================
die() {
  remark "DIED: $@"
  exit 8
} # end: die

#===  FUNCTION  ================================================================
#         NAME:  mkstaging_area
#  DESCRIPTION:  Creates a temporary staging area and set the variable
#                $STAGING_AREA to point to it
#   PARAMETERS:  STRING, mktemp template (optional)
#      RETURNS:  0, oke
#                1, not oke
#===============================================================================
mkstaging_area()
{
  local TEMPLATE RETV
  TEMPLATE="${HOME}/tmp/stage.XXXXXXXX"

  [[ -z "$1" ]] || TEMPLATE="$1"

  STAGING_AREA=$(mktemp -d ${TEMPLATE})
  RETV=$?

  if [ $RETV == 0 ]
  then
    return 0
  else
    remark "mkstaging_area failed $RETV"
    return 1
  fi

  return 0
} # end: mkstaging_area

#===  FUNCTION  ================================================================
#         NAME:  git_exp
#  DESCRIPTION:  export a git repo to a select destination
#   PARAMETERS:  STRING, source url
#                STRING, dest dir
#      RETURNS:  nothing
#===============================================================================
git_exp()
{
    SOURCEURL=$1
    DESTDIR=$2
    BASENAME=$(basename $SOURCEURL .git)

    remark "sourceurl: $SOURCEURL"
    remark "destdir: $DESTDIR"
    remark "basename: $BASENAME"
    mkdir -p $STAGING_AREA/src
    cd $STAGING_AREA/src
    git clone $SOURCEURL
    mkdir -p $DESTDIR
    cd $BASENAME
    git archive --format=tar HEAD | tar -xf - -C $DESTDIR
} # end: git_exp

#===============================================================================
# MAIN
#===============================================================================
TIMESTAMP=$(date +%Y%m%d%H%M%S)
OUTPUTDIR="bashconfig_${TIMESTAMP}"
remark "create staging area"
mkstaging_area || die "mkstaging_area failed"
[[ -z "$STAGING_AREA" ]] && die "STAGING_AREA variable is empty"

mkdir -p $STAGING_AREA/src || die "cannot create src dir"
mkdir -p $STAGING_AREA/$OUTPUTDIR/.bash || die "autoload dir not created"

git_exp "git@home:/appl/git/db/jvzantvoort-bash-config.git" \
     "$STAGING_AREA/$OUTPUTDIR/.bash"

cd $STAGING_AREA

tar -jcf $HOME/${OUTPUTDIR}.tar.bz2 $OUTPUTDIR
cd
rm -rf $STAGING_AREA

#===============================================================================
# END
#===============================================================================
