#!/data/data/com.termux/files/usr/bin/bash
# ruff.sh - Install ruff on Termux (prefers uv, falls back to pip)
set -e

echo "Installing ruff..."

if command -v uv &>/dev/null; then
    echo "Using uv to install ruff..."
    uv tool install ruff

    # uv tool install places binaries in ~/.local/bin
    export PATH="$HOME/.local/bin:$PATH"

    # Persist ~/.local/bin in PATH if not already there
    CURRENT_SHELL=$(basename "$SHELL")
    case "$CURRENT_SHELL" in
        zsh) RC="$HOME/.zshrc" ;;
        bash) RC="$HOME/.bashrc" ;;
        *) RC="$HOME/.profile" ;;
    esac

    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$RC" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$RC"
        echo "Added ~/.local/bin to PATH in $RC"
    fi
else
    echo "uv not found, falling back to pip..."
    pkg update -y
    pkg install python -y
    pip install ruff
fi

echo "ruff installed successfully:"
ruff --version
echo "Restart your shell or run 'source $RC' to ensure ruff is in PATH."