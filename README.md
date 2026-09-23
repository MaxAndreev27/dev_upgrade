# Dev Upgrade

A Bash script that updates common development tools and reports the result of each update.

## Updated tools

- Bun packages
- DDEV
- Flyctl
- Ollama
- NVM
- GitHub Copilot CLI
- Composer
- pyenv

## Requirements

The script skips a tool when its command is unavailable. Install the tools you want to update, along with `bash`, `curl`, and `git`.

## Usage

```bash
chmod +x dev_upgrade.sh
./dev_upgrade.sh
```

The script prints `⏳` while an update is running, `✅` after a successful update, and `❌` for failed or skipped updates. It exits with a non-zero status when at least one update fails or is skipped.

## License

Distributed under the [MIT License](LICENSE).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for contribution guidelines.
