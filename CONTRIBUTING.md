# Contributing

Thanks for contributing to Dev Upgrade.

## Before submitting a change

1. Open an issue first for substantial changes.
2. Keep changes focused and avoid unrelated formatting edits.
3. Use clear, user-facing output and preserve non-zero exit status on failures.
4. Run the shell syntax check:

   ```bash
   bash -n dev_upgrade.sh
   ```

5. If available, run ShellCheck:

   ```bash
   shellcheck dev_upgrade.sh
   ```

## Pull requests

- Describe what changed and why.
- Include validation results.
- Update the README when behavior, requirements, or supported tools change.
- Do not include secrets, access tokens, or machine-specific configuration.

By contributing, you agree to follow the [Code of Conduct](CODE_OF_CONDUCT.md) and license your contribution under the MIT License.
