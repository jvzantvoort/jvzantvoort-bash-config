#!/bin/bash
C_SCRIPTPATH="$(readlink -f "$0")"
C_SCRIPTDIR="$(dirname "${C_SCRIPTPATH}")"
C_TOPDIR="$(dirname "${C_SCRIPTDIR}")"

C_REPO="jvzantvoort/center_text"
C_BINNAME="center_text"
C_ARCH="linux_amd64"

readonly C_SCRIPTPATH
readonly C_SCRIPTDIR
readonly C_TOPDIR
readonly C_REPO
readonly C_BINNAME
readonly C_ARCH

function die() {
    echo "$@" >&2
    exit 1
}

mkdir -p "${HOME}/bin"

"${C_TOPDIR}/setup/github-download-latest" -a "${C_ARCH}" -r "${C_REPO}" -i lastdownload.txt

unzip "$(cat lastdownload.txt)" || die "Failed to unzip"

install -m 755 "${C_BINNAME}" "${HOME}/bin/${C_BINNAME}" || die "Failed to install"

rm "$(cat lastdownload.txt)" || die "Failed to remove zipfile"
rm lastdownload.txt || die "Failed to remove lastdownload.txt"
rm "${C_BINNAME}" || die "Failed to remove ${C_BINNAME}"
