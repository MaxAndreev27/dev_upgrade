# Dev Upgrade

A Bash script that updates development tools and reports the result of each update.

## What it updates

| Tool | Update behavior |
| --- | --- |
| mise | Updates mise itself, then upgrades tools configured in `~/.config/mise/config.toml`. |
| Bun | If managed by mise, updated through `mise`. Otherwise, updates with `bun upgrade`. |
| DDEV | Runs the official DDEV install script. |
| Flyctl | Runs `flyctl version update`. |
| OpenCode | Runs `opencode upgrade`. |
| Ollama | Checks the latest GitHub release; installs or updates Ollama only if it is missing or out of date. |
| GitHub Copilot CLI | Runs `copilot update`. |
| Composer | Runs `sudo composer self-update`. |
| uv | If managed by mise, updates through mise; otherwise, runs `uv self update`. |

For non-interactive runs, the script adds `~/.local/bin` and the mise shims directory to `PATH`.

## Requirements

Run the script with Bash. `curl` is needed for DDEV and Ollama updates; `sort -V` and `tail` are used for the Ollama version check. `sudo` is needed when Composer is installed. Network access is required for updates that download or contact remote services.

The script checks for each tool's command before updating it. Missing commands are reported as skipped and counted as failures, so they cause the script to exit with a non-zero status. Install the tools you expect the script to update; mise is needed to update mise-managed tools.

## Usage

```bash
chmod +x dev_upgrade.sh
./dev_upgrade.sh
```

The script continues through the available updates, printing `⏳` while each update runs, `✅` after success, and `❌` for failures or skipped tools. At the end it reports the success and failure counts and exits with a non-zero status if any update failed or was skipped.

Ollama's current version is compared with the latest GitHub release using the release redirect. The installer is run only when Ollama is missing or out of date.

## License

Distributed under the [MIT License](LICENSE).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.
