#!/usr/bin/env bash
# Idempotent dotfiles linker. Safe to run multiple times.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

link() {
	local src="$1"
	local dst="$2"
	mkdir -p "$(dirname "$dst")"
	ln -sfn "$src" "$dst"
	echo "linked $dst -> $src"
}

# Remove symlinks left over from the old layout (only if they are symlinks).
unlink_old() {
	local dst="$1"
	if [ -L "$dst" ]; then
		rm "$dst"
		echo "removed stale link $dst"
	fi
}

# --- shell entry point ---
link "$DOTFILES/zsh/zshrc"             "$HOME/.zshrc"
unlink_old "$HOME/.bash_profile"
unlink_old "$HOME/.bashrc"
unlink_old "$HOME/.bash_term"
unlink_old "$HOME/.toolsrc"
unlink_old "$HOME/.workspacerc"
unlink_old "$HOME/.vimrc"
unlink_old "$HOME/.tmux.conf"

# --- git ---
link "$DOTFILES/git/gitconfig"         "$HOME/.gitconfig"
link "$DOTFILES/git/gitignore_global"  "$HOME/.gitignore_global"

# --- machine-local secrets (never committed) ---
touch "$HOME/.secrets"

echo "done."
