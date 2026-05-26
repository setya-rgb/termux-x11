#!/data/data/com.termux/files/usr/bin/bash

# Termux Zsh + Antidote Setup Script
# Run: bash zsh.sh

set -e

echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "Installing Zsh, Git, and curl..."
pkg install zsh git curl -y

ANTIDOTE_DIR="$HOME/.antidote"
ZDOTDIR="$HOME"
ZSHRC="$ZDOTDIR/.zshrc"
ZSH_PLUGINS_TXT="$ZDOTDIR/.zsh_plugins.txt"
ZSH_PLUGINS_ZSH="$ZDOTDIR/.zsh_plugins.zsh"

if [[ ! -d "$ANTIDOTE_DIR" ]]; then
    echo "Cloning Antidote..."
    git clone --depth=1 https://github.com/mattmc3/antidote.git "$ANTIDOTE_DIR"
else
    echo "Antidote already installed."
fi

if [[ ! -f "$ZSH_PLUGINS_TXT" ]]; then
    echo "Creating $ZSH_PLUGINS_TXT with starter plugins..."
    cat > "$ZSH_PLUGINS_TXT" << 'EOF'
# Zsh core plugins (optional – comment out if not wanted)
mattmc3/ez-compinit          # faster compinit
zsh-users/zsh-syntax-highlighting
zsh-users/zsh-autosuggestions
zsh-users/zsh-completions
# Popular utilities
hlissner/zsh-autopair        # auto-closing brackets
# Uncomment to add more: https://github.com/unixorn/awesome-zsh-plugins
EOF
else
    echo "$ZSH_PLUGINS_TXT already exists (keeping existing)."
fi

echo "Writing $ZSHRC ..."
cat > "$ZSHRC" << 'EOF'
# ================================
# Termux Zsh + Antidote Configuration
# ================================

export ANTIDOTE_HOME="$HOME/.antidote"

zsh_plugins="${ZDOTDIR:-$HOME}/.zsh_plugins"

[[ -f "${zsh_plugins}.txt" ]] || touch "${zsh_plugins}.txt"

fpath=("${ANTIDOTE_HOME}/functions" $fpath)
autoload -Uz antidote

if [[ ! "${zsh_plugins}.zsh" -nt "${zsh_plugins}.txt" ]]; then
    antidote bundle < "${zsh_plugins}.txt" >| "${zsh_plugins}.zsh"
fi

source "${zsh_plugins}.zsh"

HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_DUPS
setopt SHARE_HISTORY

if [[ -n "$TERMUX_VERSION" ]]; then
    autoload -Uz promptinit && promptinit
    prompt -p 'termux'
    
    alias install='pkg install'
    alias update='pkg update && pkg upgrade'
    alias list='pkg list-all'
fi
EOF

if [[ "$SHELL" != *"/zsh" ]]; then
    echo "Changing default shell to Zsh..."
    chsh -s zsh
    echo "Shell changed. Please restart Termux completely."
else
    echo "Zsh is already your default shell."
fi

echo ""
echo "Setup completed!"
echo "Next steps:"
echo "   1. Restart Termux (close and reopen)."
echo "   2. Run 'antidote update' to fetch the latest plugin versions."
echo "   3. Edit ~/.zsh_plugins.txt to add/remove plugins."
echo "   4. Run 'antidote bundle < ~/.zsh_plugins.txt > ~/.zsh_plugins.zsh' after changes."
echo ""
echo "To learn more about Antidote: https://github.com/mattmc3/antidote"