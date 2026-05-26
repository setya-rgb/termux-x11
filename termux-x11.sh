#!/usr/bin/env bash

set -Eeuo pipefail

REPO="termux/termux-x11"
ARCH="$(uname -m)"

case "$ARCH" in
    aarch64|arm64)
        APK="app-arm64-v8a-debug.apk"
        ;;
    armv7l|arm)
        APK="app-armeabi-v7a-debug.apk"
        ;;
    x86_64|amd64)
        APK="app-x86_64-debug.apk"
        ;;
    i686|i386)
        APK="app-x86-debug.apk"
        ;;
    *)
        APK="app-universal-debug.apk"
        ;;
esac

TMPDIR="$(mktemp -d)"
trap 'rm -rf "$TMPDIR"' EXIT

cd "$TMPDIR"

echo "[*] Detecting latest nightly release..."

URL="$(
    curl -fsSL "https://api.github.com/repos/${REPO}/releases/tags/nightly" |
    grep -oE '"browser_download_url":[[:space:]]*"[^"]+"' |
    cut -d'"' -f4 |
    grep "${APK}$" |
    head -n1
)"

if [ -z "$URL" ]; then
    echo "[-] Failed to locate APK: $APK" >&2
    exit 1
fi

echo "[*] Downloading:"
echo "    $URL"

curl -fL# -o termux-x11.apk "$URL"

echo
echo "[+] APK saved:"
echo "    $(pwd)/termux-x11.apk"

echo
echo "[*] Install with:"
echo "    termux-open termux-x11.apk"