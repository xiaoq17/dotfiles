#!/usr/bin/env bash
# Install agent skills declared in Skillsfile. Idempotent.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLSFILE="${1:-$DOTFILES/Skillsfile}"
SKILLS_HOME="$HOME/.agents/skills"

TMP_DIRS=()
cleanup() {
	for d in "${TMP_DIRS[@]:-}"; do
		rm -rf "$d"
	done
}
trap cleanup EXIT

trim() {
	local s="$1"
	s="${s#"${s%%[![:space:]]*}"}"
	s="${s%"${s##*[![:space:]]}"}"
	printf '%s' "$s"
}

install_skill() {
	local name="$1" repo="$2" subpath="$3" ref="$4"
	local target="$SKILLS_HOME/$name"

	if [ -e "$target" ] || [ -L "$target" ]; then
		# Replace a legacy symlink from the old link-based setup;
		# leave real, non-symlink installs untouched.
		if [ -L "$target" ]; then
			rm "$target"
			echo "removed legacy symlink $target"
		else
			echo "skip $name: already installed ($target)"
			return 0
		fi
	fi

	local tmp
	tmp="$(mktemp -d)"
	TMP_DIRS+=("$tmp")

	echo "==> $name: clone $repo @ ${ref:-HEAD}"
	git clone -q --depth 1 "$repo" "$tmp/repo"

	if [ -n "$ref" ]; then
		if ! git -C "$tmp/repo" checkout -q "$ref" 2>/dev/null; then
			git -C "$tmp/repo" fetch -q --depth 1 origin "$ref" \
				&& git -C "$tmp/repo" checkout -q FETCH_HEAD
		fi
	fi

	if [ ! -d "$tmp/repo/$subpath" ]; then
		echo "error: subpath \"$subpath\" not found in $repo" >&2
		return 1
	fi

	mkdir -p "$SKILLS_HOME"
	cp -R "$tmp/repo/$subpath" "$target"

	if [ ! -f "$target/SKILL.md" ]; then
		echo "error: $name has no SKILL.md, removing" >&2
		rm -rf "$target"
		return 1
	fi

	echo "installed $name -> $target"
}

[ -f "$SKILLSFILE" ] || { echo "Skillsfile not found: $SKILLSFILE" >&2; exit 1; }

while IFS='|' read -r c1 c2 c3 c4 || [ -n "${c1:-}" ]; do
	name="$(trim "${c1:-}")"
	[ -z "$name" ] && continue
	[ "${name:0:1}" = "#" ] && continue
	repo="$(trim "${c2:-}")"
	subpath="$(trim "${c3:-}")"
	ref="$(trim "${c4:-}")"
	install_skill "$name" "$repo" "$subpath" "$ref"
done < "$SKILLSFILE"

echo "skills up to date."
