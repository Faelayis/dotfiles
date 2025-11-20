sudo dnf copr enable atim/starship
sudo dnf install starship

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="$SCRIPT_DIR/starship.toml"

if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "❌ starship.toml not found in $SCRIPT_DIR"
    exit 1
fi

echo "🔍 Found config: $CONFIG_FILE"

append_if_missing() {
    local file="$1"
    local text="$2"

    if ! grep -qF "$text" "$file" 2>/dev/null; then
        echo "$text" | sudo tee -a "$file" >/dev/null
        echo "✔ Updated: $file"
    else
        echo "ℹ Already present: $file"
    fi
}

ZSH_BLOCK=$(cat <<EOF
if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CONFIG="$CONFIG_FILE"
    eval "\$(starship init zsh)"
fi
EOF
)

BASH_BLOCK=$(cat <<EOF
if command -v starship >/dev/null 2>&1; then
    export STARSHIP_CONFIG="$CONFIG_FILE"
    eval "\$(starship init bash)"
fi
EOF
)

append_if_missing /root/.zshrc "$ZSH_BLOCK"
append_if_missing /root/.bashrc "$BASH_BLOCK"

echo ""
echo "🎉 Starship config installed for root!"
echo "➡ Location: $CONFIG_FILE"

