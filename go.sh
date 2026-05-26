#!/data/data/com.termux/files/usr/bin/bash

# Termux Go Setup Script
# Run: bash go.sh

set -e

echo "Updating Termux packages..."
pkg update -y && pkg upgrade -y

echo "Installing Go..."
pkg install golang -y

# Detect current shell
CURRENT_SHELL=$(basename "$SHELL")
RC_FILE=""

case "$CURRENT_SHELL" in
    zsh)
        RC_FILE="$HOME/.zshrc"
        ;;
    bash)
        RC_FILE="$HOME/.bashrc"
        ;;
    *)
        echo "Unknown shell: $CURRENT_SHELL. Will only add exports to .profile"
        RC_FILE="$HOME/.profile"
        ;;
esac

GOPATH="$HOME/go"
GOBIN="$GOPATH/bin"

# Add Go environment variables if not already present
if [[ -f "$RC_FILE" ]]; then
    if ! grep -q "export GOPATH=" "$RC_FILE"; then
        echo "Adding Go environment variables to $RC_FILE"
        cat >> "$RC_FILE" << EOF

# Go environment
export GOPATH=\$HOME/go
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:\$GOBIN
EOF
    else
        echo "Go environment already configured in $RC_FILE"
    fi
else
    echo "No rc file found. Creating $RC_FILE"
    cat > "$RC_FILE" << EOF
# Go environment
export GOPATH=\$HOME/go
export GOBIN=\$GOPATH/bin
export PATH=\$PATH:\$GOBIN
EOF
fi

# Create the standard Go workspace directories
echo "Creating Go workspace directories..."
mkdir -p "$GOPATH"/{bin,src,pkg}

# Set environment for current session
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export PATH="$PATH:$GOBIN"

echo ""
echo "Go setup completed!"
go version
echo ""
echo "GOPATH: $GOPATH"
echo "GOBIN:  $GOBIN"
echo ""
echo "Next steps:"
echo "   1. Restart Termux or run 'source $RC_FILE' to apply changes."
echo "   2. Create your first program:"
echo "      mkdir -p \$GOPATH/src/hello && cd \$GOPATH/src/hello"
echo "      cat > main.go << EOF"
echo "      package main"
echo "      import \"fmt\""
echo "      func main() { fmt.Println(\"Hello, Termux!\") }"
echo "      EOF"
echo "   3. Build and run: go build && ./hello"
echo ""
echo "To verify your installation, run: go env"