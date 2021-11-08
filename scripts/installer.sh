#!/bin/sh

LATST_RELEASE_URL=https://api.github.com/repos/thombashi/pre-commit-bin/releases/latest
INSTALL_DIR_PATH=/usr/local/bin/
VERSION_CODENAME=$(\grep -Po "(?<=VERSION_CODENAME=)[a-z]+" /etc/os-release)
URL=$(curl -sSL "$LATST_RELEASE_URL" | jq -r ".assets[] | select(.name | contains(\"_linux_${VERSION_CODENAME}\")) | .browser_download_url")
curl -SL "$URL" | tar xzf - -C "$INSTALL_DIR_PATH"

"${INSTALL_DIR_PATH}"/pre-commit --version
