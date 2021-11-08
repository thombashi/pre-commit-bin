#!/bin/sh

set -eu

TMP_DIR=$(mktemp -d)
LATST_RELEASE_URL=https://api.github.com/repos/thombashi/pre-commit-bin/releases/latest
INSTALL_DIR_PATH=/usr/local/bin/
RELEASE_INFO_JSON="${TMP_DIR}/release_info.json"
VERSION_CODENAME=$(\grep -Po "(?<=VERSION_CODENAME=)[a-z]+" /etc/os-release)

trap 'rm -rf ${TMP_DIR}' 0 1 2 3 15
cd "${TMP_DIR}"
curl -sSL "$LATST_RELEASE_URL" | jq -r ".assets[]" > "$RELEASE_INFO_JSON"

TARBALL_URL=$(jq -r "select(.name | contains(\"_linux_${VERSION_CODENAME}\")) | .browser_download_url" "$RELEASE_INFO_JSON")
TARBALL_FILENAME=$(jq -r "select(.name | contains(\"_linux_${VERSION_CODENAME}\")) | .name" "$RELEASE_INFO_JSON")
SHASUM_URL=$(jq -r 'select(.name == "sha256_pre-commit.txt") | .browser_download_url' "$RELEASE_INFO_JSON")

curl -SL "$TARBALL_URL" -o "$TARBALL_FILENAME"
curl -sSL "$SHASUM_URL" | \grep "$TARBALL_FILENAME" | sha256sum -c -
tar xzf "$TARBALL_FILENAME"
./pre-commit --version

mv ./pre-commit "$INSTALL_DIR_PATH"
