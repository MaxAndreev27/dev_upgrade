#!/usr/bin/env bash

set -uo pipefail

successful_updates=0
failed_updates=0

# Пользовательские бинарники и mise-шимы нужны и в неинтерактивных запусках
# (cron, systemd, CI), где ~/.zshrc и ~/.zprofile не читаются.
export PATH="$PATH:$HOME/.local/bin:$HOME/.local/share/mise/shims"

run_update() {
	local name="$1"
	shift

	printf '\n⏳ Updating %s...\n' "$name"
	if "$@"; then
		printf '✅ %s updated successfully\n' "$name"
		((successful_updates++))
	else
		printf '❌ Failed to update %s\n' "$name" >&2
		((failed_updates++))
	fi
}

require_command() {
	local command_name="$1"

	if ! command -v "$command_name" >/dev/null 2>&1; then
		printf '❌ Skipping %s: command not found\n' "$command_name" >&2
		((failed_updates++))
		return 1
	fi
}

install_or_update_ollama() {
	local installed_version=''
	local latest_release_url
	local latest_version
	local version_output

	version_output="$(ollama --version 2>/dev/null)"
	if [[ "$version_output" =~ ([0-9]+(\.[0-9]+)+) ]]; then
		installed_version="${BASH_REMATCH[1]}"
	fi
	latest_release_url="$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/ollama/ollama/releases/latest)"
	latest_version="${latest_release_url##*/v}"

	if [[ ! "$latest_version" =~ ^[0-9]+(\.[0-9]+)+$ ]]; then
		printf '❌ Could not determine the latest Ollama version\n' >&2
		return 1
	fi

	if [[ -n "$installed_version" ]] && [[ "$(printf '%s\n%s\n' "$installed_version" "$latest_version" | sort -V | tail -n 1)" == "$installed_version" ]]; then
		printf 'Ollama %s is already up to date\n' "$installed_version"
		return 0
	fi

	printf 'Updating Ollama from %s to %s\n' "${installed_version:-not installed}" "$latest_version"
	curl -fsSL https://ollama.com/install.sh | sh
}

printf 'Starting development tools update...\n'

# mise: сам себя, затем все инструменты из ~/.config/mise/config.toml
# (node, bun, pnpm, а также uv/python, если они когда-нибудь переедут под mise).
if require_command mise; then
	run_update 'mise' mise self-update
	run_update 'mise tools (node, bun, pnpm)' mise upgrade --yes
fi

# bun вне mise (например, на новой машине) — обновляем его собственным способом.
if require_command bun && [[ "$(command -v bun)" != "$HOME/.local/share/mise/"* ]]; then
	run_update 'Bun (standalone)' bun upgrade
fi

if require_command curl; then
	run_update 'DDEV' bash -o pipefail -c 'curl -fsSL https://ddev.com/install.sh | bash'
fi

if require_command flyctl; then
	run_update 'Flyctl' flyctl version update
fi

if require_command opencode; then
	run_update 'OpenCode' opencode upgrade
fi

if require_command curl; then
	run_update 'Ollama' install_or_update_ollama
fi

if require_command copilot; then
	run_update 'GitHub Copilot CLI' copilot update
fi

if require_command composer; then
	run_update 'Composer' sudo composer self-update
fi

# uv пока standalone. Если позже переедет под mise — обновим через mise.
if require_command uv; then
	if [[ "$(command -v uv)" == "$HOME/.local/share/mise/"* ]]; then
		run_update 'uv' mise upgrade uv
	else
		run_update 'uv' uv self update
	fi
fi

printf '\nUpdate complete: ✅ %d succeeded, ❌ %d failed or skipped\n' \
	"$successful_updates" "$failed_updates"

((failed_updates == 0))
