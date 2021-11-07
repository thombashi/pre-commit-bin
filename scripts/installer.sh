#!/bin/sh

INSTALL_DIR_PATH=/usr/local/bin/
VERSION_CODENAME=$(\grep -Po "(?<=VERSION_CODENAME=)[a-z]+" /etc/os-release)
URL=$(curl -sSL https://api.github.com/repos/thombashi/pre-commit-bin/releases/latest | jq -r ".assets[] | select(.name | contains(\"_linux_${VERSION_CODENAME}\")) | .browser_download_url")
curl -SL "$URL" | tar xzf - -C "$INSTALL_DIR_PATH"

"${INSTALL_DIR_PATH}"/pre-commit --version
