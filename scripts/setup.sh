#!/usr/bin/env bash

set -euo pipefail

echo "[START] Start to run ${BASH_SOURCE[0]}..."

if [[ $EUID -eq 0 ]]; then
  echo "This script cannot be run as root. Make sue you have sudo privilege"
  echo
  exit 1
fi

# Check a host service is up and running within a given time (default 30 seconds)
#
# @param host IP or hostname (required)
# @param port a service port (required)
# @param description a service description (required)
# @param duration_seconds (optional)
# @return void or exit error
wait_for() {
  host="${1}"
  port="${2}"
  description="${3}"
  duration_seconds=30

  if [ ! -z "${4:-}" ]; then
    duration_seconds="$4"
  fi

  duration=$(echo "${duration_seconds} / 5" | bc)

  echo "-- wait ${duration_seconds}s for start up ${description}..."
  for ((i = 1; i <= ${duration}; i++)); do
    if nc -z "${host}" "${port}"; then
      return 0
    fi
    echo "  no unavailable yet - sleeping"
    sleep 5
  done
  echo "-- ${description} not started after ${duration_seconds}s, exit"
  exit 1
}

# Install one or more packages
#
# @param list of packages
# @return void or exit error
install-package() {
  local pkgs=($@)

  if [[ "${#pkgs[@]}" -eq 0 ]]; then
    echo "Wrong number arguments. Expected at least 1"
    exit 2
  fi

  for pkg in "${pkgs[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "++ $pkg already installed"
    else
      echo "++ install $pkg..."
      sudo apt install -y "$pkg" > /dev/null 2>&1
    fi
  done
}

# Update one or more packages
#
# @param list of packages
# @return void or exit error
update-package() {
  local pkgs=($@)


  if [[ "${#pkgs[@]}" -eq 0 ]]; then
    echo "Wrong number arguments. Expected at least 1"
    exit 2
  fi

  for pkg in "${pkgs[@]}"; do
    echo "++ update $pkg..."
    sudo apt install -y "$pkg" > /dev/null 2>&1
  done
}

# Uninstall one or more packages
#
# @param list of packages
# @return void or exit error
uninstall-package() {
  local pkgs=($@)

  if [[ "${#pkgs[@]}" -eq 0 ]]; then
    echo "Wrong number arguments. Expected at least 1"
    exit 2
  fi

  for pkg in "${pkgs[@]}"; do
    if dpkg -s "$pkg" >/dev/null 2>&1; then
      echo "++ remove $pkg..."
      sudo apt remove -y "$pkg" > /dev/null 2>&1
    else
      echo "++ $pkg not found"
    fi
  done
}

# Refresh (aka udpate) local package repository
# @return void or exit error
do_refresh_repo() {
  echo "-- refresh repository..."

  sudo apt update > /dev/null 2>&1
}

# Run system upgrade
#
# @param upgrade_method (optional) By default method is 'upgrade', then all supported by apt such as full-upgrade
# @return void or exit error
do_system_upgrade() {
  local upgrade_method='full-upgrade'

  if [[ $# -gt 1 ]]; then
    upgrade_method="${1}"
  fi

  echo "-- system upgrade (method: ${upgrade_method})..."
  sudo apt "${upgrade_method}" -y > /dev/null 2>&1
}

export DEBIAN_FRONTEND='noninteractive'
export SKIP_SYS_UPDATE="${SKIP_SYS_UPDATE:-0}"

CUR_DIR="$(cd $(dirname ${BASH_SOURCE[0]}) && pwd -P)"

if [[ "${SKIP_SYS_UPDATE}" -eq 0 ]]; then
  echo "Before installing any server dependencies..."
  do_refresh_repo
  do_system_upgrade
fi

install-package build-essential wget curl gnupg zip unzip git
install-package pkg-config libudev-dev libssl-dev

echo "Common dependencies installed"

. "${CUR_DIR}/install-nodejs.sh"
. "${CUR_DIR}/install-rust.sh"
. "${CUR_DIR}/install-solana.sh"

echo "Removing leftover after provisioning the machine..."
. "${CUR_DIR}/apt-cleanup.sh"
