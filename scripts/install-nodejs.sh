#!/usr/bin/env bash

# Install Node.js 10.x using nvm 0.35.x

set -euo pipefail

echo
echo "[start] Run ${BASH_SOURCE[0]}..."

if [[ $EUID -eq 0 ]]; then
  echo "This script cannot be run as root. Make sue you have sudo privilege"
  echo
  exit 1
fi

do_install() {
  nvm install "${NODE_PKG_LATEST_VERSION}" > /dev/null 2>&1
  nvm alias default "${NODE_PKG_LATEST_VERSION}" > /dev/null 2>&1
}

PKG_LATEST_VERSION='0.39.1'
PKG_DOWNLOAD_LINK="https://raw.githubusercontent.com/nvm-sh/nvm/v${PKG_LATEST_VERSION}/install.sh"

NODE_PKG_LATEST_VERSION='16.14.2'

NVM_CMD="${HOME}/.nvm/nvm.sh"

# unhold previous package (apt pin version used instead)
#
# NOTE: previously was used package by Nodesource, now replaced by nvm
if sudo apt-mark showhold | grep 'nodejs' > /dev/null 2>&1; then
  echo "-- unlock version package (replace by pin version)..."
  sudo apt-mark unhold nodejs > /dev/null 2>&1
fi

if dpkg -s nodejs >/dev/null 2>&1; then
  uninstall-package nodejs
fi

echo "Install nvm..."

if [[ -f "${NVM_CMD}" ]]; then
  source "${NVM_CMD}"
fi

# install or upgrade nvm
if command -v nvm > /dev/null 2>&1; then
  pkg_version="$(nvm --version)"

  if [[ "${pkg_version}" != "${PKG_LATEST_VERSION}" ]]; then
    echo "-- upgrading version from ${pkg_version} to ${PKG_LATEST_VERSION}..."
    curl -fsSL -o- "${PKG_DOWNLOAD_LINK}" | bash > /dev/null 2>&1
    source "${NVM_CMD}"
  else
    echo "-- no action required. Current version: ${pkg_version}"
  fi
else
  echo "-- installing version ${PKG_LATEST_VERSION}..."
  curl -fsSL -o- "${PKG_DOWNLOAD_LINK}" | bash > /dev/null 2>&1
  source "${NVM_CMD}"
fi

echo "Install nodejs..."

# install or upgrade nodejs
if command -v node > /dev/null 2>&1; then
  pkg_version="$(node --version)"
  pkg_version="${pkg_version#*v}"
  if [[ "${pkg_version}" != "${NODE_PKG_LATEST_VERSION}" ]]; then
    echo "-- upgrading version from ${pkg_version} to ${NODE_PKG_LATEST_VERSION}..."
    do_install
  else
    echo "-- no action required. Current version: ${pkg_version}"
  fi
else
  echo "-- installing version ${NODE_PKG_LATEST_VERSION}..."
  do_install
fi

echo "-- Node.js is ready to use"
