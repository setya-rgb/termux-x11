#!/data/data/com.termux/files/usr/bin/bash
# termux-properties.sh - Create a useful termux.properties file with blink features

set -e

TERMUX_DIR="$HOME/.termux"
PROPERTIES_FILE="$TERMUX_DIR/termux.properties"

mkdir -p "$TERMUX_DIR"

if [[ -f "$PROPERTIES_FILE" ]]; then
    echo "Backing up existing termux.properties to termux.properties.bak"
    cp "$PROPERTIES_FILE" "$PROPERTIES_FILE.bak"
fi

echo "Creating $PROPERTIES_FILE with recommended settings (including blink)..."

cat > "$PROPERTIES_FILE" << 'EOF'
# Termux properties configuration
# After editing, run "termux-reload-settings" to apply changes.

# ==========================
# Extra keys row
# ==========================

# Enable extra keys row
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]

# Alternative compact layout (uncomment to use instead)
# extra-keys = [['ESC','/','-','UP','PGUP'],['TAB','CTRL','ALT','DOWN','PGDN']]

# ==========================
# Volume keys
# ==========================

# Use volume keys to control terminal text size
volume-keys = volume-up-text-size

# Or to send Escape: volume-keys = volume-up-escape
# Or to send specific keys: volume-keys = volume-up-key KEY_C, volume-down-key KEY_D

# ==========================
# Bell / sound
# ==========================

# Make the screen blink on bell instead of vibrating or beeping
bell-character = blink

# ==========================
# Cursor blink
# ==========================

# Enable blinking cursor
use-blinking-cursor = true

# ==========================
# Touchpad / mouse
# ==========================

# Enable mouse support in terminal applications
mouse-support = true

# ==========================
# Keyboard shortcuts
# ==========================

# Ctrl + space -> send ESC (useful for vim)
shortcut.create-session = ctrl + t
shortcut.next-session = ctrl + shift + t
shortcut.rename-session = ctrl + shift + 2

# ==========================
# Display
# ==========================

# Full-screen mode (requires termux-reload-settings)
fullscreen = false

# Use black status bar icons for light themes (on Android 8+)
use-black-ui = true

# ==========================
# Terminal behaviour
# ==========================

# Allow running multiple Termux sessions
allow-external-apps = true

# Default working directory for new sessions (default is ~)
# default-working-directory = /sdcard

# ==========================
# Styling
# ==========================

# Font (use 'monospace' or pick another installed font)
# font = monospace

# Terminal scrollback rows
terminal-transcript-rows = 2000
EOF

echo "termux.properties created successfully with blink settings."
echo "To apply the changes, run: termux-reload-settings"
echo "Or restart the Termux app entirely."