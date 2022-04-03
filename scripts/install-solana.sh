#!/usr/bin/env bash

# Install Solana

set -euo pipefail

echo "[START] Start to run ${BASH_SOURCE[0]}..."

if [[ $EUID -eq 0 ]]; then
  echo "This script cannot be run as root. Make sure you have sudo privilege"
  echo
  exit 1
fi

PKG_LATEST_VERSION='1.9.5'

echo "Install Solana..."

if command -v solana > /dev/null 2>&1; then
  solana --version
else
  # curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  curl -sSfL https://release.solana.com/v${PKG_LATEST_VERSION}/install | sh -s
fi

echo "Solana is ready to use"
echo
echo
echo "Testing your setup following the instructions below:"
echo
echo "-   set Solana provider URL to the Devnet cluster"
echo
echo "    $> solana config set --url https://api.devnet.solana.com"
echo
echo "-   generate a new keypair account. When prompted for a password, you can enter one, or"
echo "    leave it blank and press enter"
echo
echo "    $> solana-keygen new --force"
echo
echo "-   now that the account is created, you can use the airdrop program to obtain some"
echo "    SOL tokens."
echo
echo "    $> solana airdrop 2"
echo
echo "    Note: An output to similar to the one below, confirms the trasferring of SOL"
echo "    to your account"
echo
echo "    $> solana airdrop 2"
echo "    Requesting airdrop of 2 SOL"
echo
echo "    Signature: 3wBEsK1UH8LwFW37mS45yYE9jKQUSswHa9WRF4dDJ89YdbCh9vBTf5rQT9eSMGor8cMxZnxUPgaTyTAd3HQjMZiZ"
echo
echo "    2 SOL"
echo
echo
