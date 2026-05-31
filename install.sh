#!/bin/bash
# Written by Joren (SickMcNugget)
# Date: 2026-05-31
#
# This script prepares a system to use my dotfiles, installing chezmoi.
#
# If it isn't installed, Proton Pass CLI is installed, and a login is
# attempted if it isn't already logged in.
# Installs chezmoi and applies the dotfiles.
set -euo pipefail
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

pass_cli="$HOME/.local/bin/pass-cli"
if command -v pass-cli >/dev/null; then
	pass_cli=pass-cli
else
	pass_cli="$HOME/.local/bin/pass-cli"
	if command -v curl >/dev/null; then
		curl -fsSL https://proton.me/download/pass-cli/install.sh | bash
	elif command -v wget >/dev/null; then
		wget -qO- https://proton.me/download/pass-cli/install.sh | bash
	else
		echo "To install pass-cli, you must have curl or wget installed." >&2
		exit 1
	fi
fi

if ! "$pass_cli" test >/dev/null 2>&1; then
	if ! "$pass_cli" login; then
		echo "These dotfiles require a secret manager to function. Please login to pass-cli" >&2
		exit 1
	fi
fi

if ! command -v chezmoi >/dev/null; then
	bin_dir="$HOME/.local/bin"
	chezmoi="$bin_dir/chezmoi"
	if command -v curl >/dev/null; then
		sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$bin_dir"
	elif command -v wget >/dev/null; then
		sh -c "$(wget -qO- get.chezmoi.io)" -- -b "$bin_dir"
	else
		echo "To install chezmoi, you must have curl or wget installed." >&2
		exit 1
	fi
else
	chezmoi=chezmoi
fi

exec "$chezmoi" init --apply "--source=$SCRIPT_DIR"
