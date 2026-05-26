#!/data/data/com.termux/files/usr/bin/bash
# uv.sh - Install uv on Termux
set -e

echo "Installing uv..."
curl -LsSf https://astral.sh/uv/install.sh | sh

# Add ~/.cargo/bin to PATH for current session
export PATH="$HOME/.cargo/bin:$PATH"

# Detect shell config file
CURRENT_SHELL=$(basename "$SHELL")
case "$CURRENT_SHELL" in
    zsh) RC="$HOME/.zshrc" ;;
    bash) RC="$HOME/.bashrc" ;;
    *) RC="$HOME/.profile" ;;
esac

# Persist PATH in the config file
if ! grep -q 'export PATH="$HOME/.cargo/bin:$PATH"' "$RC" 2>/dev/null; then
    echo 'export PATH="$HOME/.cargo/bin:$PATH"' >> "$RC"
    echo "Added uv to PATH in $RC"
fi

echo "uv installed successfully:"
uv --version
echo "Restart Termux or run 'source $RC' to use uv immediately."