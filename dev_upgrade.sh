#!/bin/bash

bun upgrade

curl -fsSL https://ddev.com/install.sh | bash

flyctl version update

curl -fsSL https://ollama.com/install.sh | sh

sudo composer self-update

pyenv update