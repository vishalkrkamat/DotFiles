#!/usr/bin/env bash
set -euo pipefail

theme_ids=(mocha macchiato frappe latte nord rose-pine tokyo-night everforest)
theme_labels=(
    'Catppuccin Mocha'
    'Catppuccin Macchiato'
    'Catppuccin Frappé'
    'Catppuccin Latte'
    'Nord'
    'Rosé Pine Moon'
    'Tokyo Night Storm'
    'Everforest'
)

state_file="${XDG_STATE_HOME:-$HOME/.local/state}/dotfiles-theme-picker/current-theme"
current_theme=''
if [[ -r "$state_file" ]]; then
    IFS= read -r current_theme < "$state_file" || true
fi
if [[ -z "$current_theme" && -r "$HOME/.config/nvim/lua/core/current_theme.lua" ]]; then
    current_theme=$(sed -n 's/.*id = "\([^"]*\)".*/\1/p' "$HOME/.config/nvim/lua/core/current_theme.lua" | head -n 1)
fi
[[ -n "$current_theme" ]] || current_theme=mocha

current_label=''
items=()
for index in "${!theme_ids[@]}"; do
    label=${theme_labels[$index]}
    if [[ ${theme_ids[$index]} == "$current_theme" ]]; then
        current_label=$label
        items+=("$label  ★ current")
    else
        items+=("$label")
    fi
done

choice=$(printf '%s\n' "${items[@]}" |
    fuzzel --dmenu --prompt="Theme (active: ${current_label:-unknown}): " --width=54 --lines=8) || exit 0
choice=${choice%  ★ current}

case "$choice" in
    'Catppuccin Mocha') theme=mocha ;;
    'Catppuccin Macchiato') theme=macchiato ;;
    'Catppuccin Frappé') theme=frappe ;;
    'Catppuccin Latte') theme=latte ;;
    Nord) theme=nord ;;
    'Rosé Pine Moon') theme=rose-pine ;;
    'Tokyo Night Storm') theme=tokyo-night ;;
    Everforest) theme=everforest ;;
    *) exit 0 ;;
esac

exec python3 "$HOME/.config/script/apply_theme.py" "$theme"
