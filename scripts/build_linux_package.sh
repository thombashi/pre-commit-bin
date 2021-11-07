#!/usr/bin/env bash

set -eux

if [ $# -lt 2 ]; then
  echo "Usage: $(basename $0) <PACKAGE VERSION> <PATH TO SRC>" 1>&2
  exit 1
fi

PKG_VERSION="$1"
SRC_DIR="$2"

DPKG_BUILD_DIR="dpkg_build"
DIST_DIR_NAME="dist"
INSTALL_DIR_PATH="/usr/bin"
BUILD_DIR_PATH="./${DPKG_BUILD_DIR}/${INSTALL_DIR_PATH}"
PKG_NAME="pre-commit"
SYSTEM=$(python -c "import platform; print(platform.system().casefold())")
MACHINE=$(python -c "import platform; print(platform.machine().casefold())")

if [ "$MACHINE" = "x86_64" ]; then
  MACHINE="amd64"
fi

# initialize
rm -rf "$DIST_DIR_NAME" "$DPKG_BUILD_DIR" build
mkdir -p "${DPKG_BUILD_DIR}/DEBIAN" "$DIST_DIR_NAME"

pip install -q --upgrade "pip>=21.1" "pyinstaller>=4.6"

echo $PKG_NAME $PKG_VERSION

# build an executable binary file
pyinstaller "${SRC_DIR}/pre_commit/main.py" --clean --onefile --distpath $BUILD_DIR_PATH --name $PKG_NAME

${BUILD_DIR_PATH}/${PKG_NAME} --version

# build a deb package
cat << _CONTROL_ > "${DPKG_BUILD_DIR}/DEBIAN/control"
Package: $PKG_NAME
Version: $PKG_VERSION
Maintainer: Tsuyoshi Hombashi <tsuyoshi.hombashi@gmail.com>
Architecture: $MACHINE
Description: $PKG_NAME binary package
Homepage: https://github.com/thombashi/$PKG_NAME
Priority: extra
_CONTROL_

VERSION_CODENAME=$(\grep -Po "(?<=VERSION_CODENAME=)[a-z]+" /etc/os-release)

fakeroot dpkg-deb --build "$DPKG_BUILD_DIR" "$DIST_DIR_NAME"
rename -v "s/_amd64.deb/_${VERSION_CODENAME}_amd64.deb/" ${DIST_DIR_NAME}/*

# generate an archive file
cd "$BUILD_DIR_PATH"
ARCHIVE_EXTENSION=tar.gz
ARCHIVE_FILE="${PKG_NAME}_${PKG_VERSION}_${SYSTEM}_${VERSION_CODENAME}_${MACHINE}.${ARCHIVE_EXTENSION}"
tar -zcvf "$ARCHIVE_FILE" "$PKG_NAME"
mv "$ARCHIVE_FILE" "$(git rev-parse --show-toplevel)/${DIST_DIR_NAME}/"
