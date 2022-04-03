#!/usr/bin/env bash

# Remove leftover after installing any package. Base on https://github.com/chr4-cookbooks/apt_cleanup

set -euo pipefail

echo "[START] Start to run ${BASH_SOURCE[0]}..."

if [[ $EUID -eq 0 ]]; then
  echo "This script cannot be run as root. Make sue you have sudo privilege"
  echo
  exit 1
fi

export DEBIAN_FRONTEND=${DEBIAN_FRONTEND:-noninteractive}

echo "Clean up system after packages installation..."

echo "-- run autoremove..."
sudo apt autoremove -y > /dev/null 2>&1 || true

echo "-- remove old kernels..."
sudo apt-get purge -y "$(dpkg -l | grep '^rc' | grep 'linux-image-[0-9]' | awk '{print $2}')" > /dev/null 2>&1 || true

echo "-- run purge..."
sudo apt-get purge -y "$(dpkg -l | grep '^rc' | awk '{print $2}')" > /dev/null 2>&1 || true

echo "-- run autoclean..."
# Comment out if you want an aggressive clean and uncomment the line below
# sudo apt-get autoclean -y > /dev/null 2>&1 || true
sudo apt-get clean -y > /dev/null 2>&1 || true
