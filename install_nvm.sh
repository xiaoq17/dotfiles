#!/usr/bin/env bash
# Install nvm (Node Version Manager) by cloning the latest release.
# nvm is not a Homebrew formula and is not recommended for brew install.
set -euo pipefail

NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
REPO="https://github.com/nvm-sh/nvm"

if [ -s "$NVM_DIR/nvm.sh" ]; then
	echo "nvm already installed at $NVM_DIR"
	exit 0
fi

echo "==> resolving latest nvm release"
latest="$(git ls-remote --tags --refs "$REPO" \
	| grep -oE 'v[0-9]+\.[0-9]+\.[0-9]+$' \
	| sort -V | tail -1)"
[ -n "$latest" ] || { echo "error: could not resolve latest nvm tag" >&2; exit 1; }

echo "==> clone nvm $latest -> $NVM_DIR"
git clone -q --depth 1 --branch "$latest" "$REPO" "$NVM_DIR"

echo "nvm $latest installed. Run 'nvm install --lts' to add Node."
