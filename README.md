# pre-commit-bin
Single binary packages of [pre-commit/pre-commit](https://github.com/pre-commit/pre-commit)

[![Build and release](https://github.com/thombashi/pre-commit-bin/actions/workflows/build_and_release.yml/badge.svg)](https://github.com/thombashi/pre-commit-bin/actions/workflows/build_and_release.yml)


## Installation: Ubuntu executable binary

```
curl -sSL https://raw.githubusercontent.com/thombashi/pre-commit-bin/main/scripts/installer.sh | sudo bash
```

## Installation: Ubuntu deb package
1. Navigate to [release](https://github.com/thombashi/pre-commit-bin/releases) page
1. Download the `deb` package that matches the platform of your environment
2. Execute `sudo dpkg -i pre-commit_*_amd64.deb`
