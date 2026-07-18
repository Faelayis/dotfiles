#!/bin/sh
set -eu

dir=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
mkdir -p "$HOME/.config/ghostty"
printf 'config-file = "%s/config.ghostty"\n' "$dir" > "$HOME/.config/ghostty/config.ghostty"
