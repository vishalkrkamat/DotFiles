#!/usr/bin/env bash
set -euo pipefail

version=1.0.3
cache="$HOME/.cache/dotfiles-theme-assets"
themes="$HOME/.local/share/themes"
kvantum="$HOME/.config/Kvantum"
mkdir -p "$cache" "$themes" "$kvantum"

for flavor in mocha macchiato frappe latte; do
    archive="$cache/catppuccin-${flavor}.zip"
    url="https://github.com/catppuccin/gtk/releases/download/v${version}/catppuccin-${flavor}-mauve-standard%2Bdefault.zip"
    curl -fsSL "$url" -o "$archive"
    unzip -oq "$archive" -d "$themes"
done

archive="$cache/catppuccin-kvantum.tar.gz"
curl -fsSL https://codeload.github.com/catppuccin/Kvantum/tar.gz/refs/heads/main -o "$archive"
for flavor in mocha macchiato frappe latte; do
    tar -xzf "$archive" -C "$kvantum" --strip-components=2 \
        "kvantum-main/themes/catppuccin-${flavor}-mauve"
done

printf 'Installed Catppuccin GTK and Kvantum themes. Nord uses the CachyOS/Nordic themes already on this system.\n'
