#!/usr/bin/env bash

# Install Rust

set -euo pipefail

echo "[START] Start to run ${BASH_SOURCE[0]}..."

if [[ $EUID -eq 0 ]]; then
  echo "This script cannot be run as root. Make sure you have sudo privilege"
  echo
  exit 1
fi

install-cargo-package() {
  local pkgs=($@)

  if [[ "${#pkgs[@]}" -eq 0 ]]; then
    echo "Wrong number arguments. Expected at least 1"
    exit 2
  fi

  for pkg in "${pkgs[@]}"; do
    if cargo list --list | grep "$pkg" > /dev/null 2>&1; then
      echo "++ $pkg is already installed"
    else
      echo "++ install $pkg..."
      cargo install "$pkg"
    fi
  done
}

echo "Install Rust..."

if command -v rustc > /dev/null 2>&1; then
  rustc --version
else
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
fi

source ~/.cargo/env

# Update Rust Toolchain
rustup update

# install-cargo-package wasm-pack

echo "Rust is ready to use"
