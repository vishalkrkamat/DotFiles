#!/usr/bin/env python3
"""Apply one coordinated palette to the managed desktop configs."""

from __future__ import annotations

import re
import os
import shutil
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[3]
HOME = Path.home()

PALETTE_KEYS = (
    "rosewater", "flamingo", "pink", "mauve", "red", "maroon", "peach",
    "yellow", "green", "teal", "sky", "sapphire", "blue", "lavender",
    "text", "subtext1", "subtext0", "overlay2", "overlay1", "overlay0",
    "surface2", "surface1", "surface0", "base", "mantle", "crust",
)

PALETTES = {
    "mocha": dict(zip(PALETTE_KEYS, "f5e0dc f2cdcd f5c2e7 cba6f7 f38ba8 eba0ac fab387 f9e2af a6e3a1 94e2d5 89dceb 74c7ec 89b4fa b4befe cdd6f4 bac2de a6adc8 9399b2 7f849c 6c7086 585b70 45475a 313244 1e1e2e 181825 11111b".split())),
    "macchiato": dict(zip(PALETTE_KEYS, "f4dbd6 f0c6c6 f5bde6 c6a0f6 ed8796 ee99a0 f5a97f eed49f a6da95 8bd5ca 91d7e3 7dc4e4 8aadf4 b7bdf8 cad3f5 b8c0e0 a5adcb 939ab7 8087a2 6e738d 5b6078 494d64 363a4f 24273a 1e2030 181926".split())),
    "frappe": dict(zip(PALETTE_KEYS, "f2d5cf eebebe f4b8e4 ca9ee6 e78284 ea999c ef9f76 e5c890 a6d189 81c8be 99d1db 85c1dc 8caaee babbf1 c6d0f5 b5bfe2 a5adce 949cbb 838ba7 737994 626880 51576d 414559 303446 292c3c 232634".split())),
    "latte": dict(zip(PALETTE_KEYS, "dc8a78 dd7878 ea76cb 8839ef d20f39 e64553 fe640b df8e1d 40a02b 179299 04a5e5 209fb5 1e66f5 7287fd 4c4f69 5c5f77 6c6f85 7c7f93 8c8fa1 9ca0b0 acb0be bcc0cc ccd0da eff1f5 e6e9ef dce0e8".split())),
    "nord": dict(zip(PALETTE_KEYS, "d08770 bf616a b48ead 88c0d0 bf616a b48ead d08770 ebcb8b a3be8c 8fbcbb 88c0d0 81a1c1 81a1c1 5e81ac eceff4 e5e9f0 d8dee9 e5e9f0 d8dee9 4c566a 434c5e 3b4252 333a47 2e3440 272c36 242933".split())),
    "rose-pine": dict(zip(PALETTE_KEYS, "f6c177 eb6f92 ea9a97 c4a7e7 eb6f92 eb6f92 f6c177 f6c177 31748f 9ccfd8 9ccfd8 3e8fb0 3e8fb0 c4a7e7 e0def4 908caa 6e6a86 6e6a86 59546d 393552 56526e 393552 2a273f 232136 2a273f 191724".split())),
    "tokyo-night": dict(zip(PALETTE_KEYS, "f7768e f7768e bb9af7 bb9af7 f7768e f7768e ff9e64 e0af68 9ece6a 73daca 7dcfff 73daca 7aa2f7 bb9af7 c0caf5 a9b1d6 9aa5ce 737aa2 565f89 414868 3b4261 3b4261 292e42 24283b 1f2335 1a1b26".split())),
    "everforest": dict(zip(PALETTE_KEYS, "e69875 e67e80 d699b6 d699b6 e67e80 e67e80 e69875 dbbc7f a7c080 83c092 80aa9e 7fbbb3 7fbbb3 d699b6 d3c6aa 9da9a0 859289 7a8478 56635f 4f585e 475258 3d484d 343f44 2d353b 272e33 232a2e".split())),
}

THEMES = {
    "mocha": {"label": "Catppuccin Mocha", "family": "catppuccin", "flavor": "mocha", "gtk": "catppuccin-mocha-mauve-standard+default", "kvantum": "catppuccin-mocha-mauve", "dark": True},
    "macchiato": {"label": "Catppuccin Macchiato", "family": "catppuccin", "flavor": "macchiato", "gtk": "catppuccin-macchiato-mauve-standard+default", "kvantum": "catppuccin-macchiato-mauve", "dark": True},
    "frappe": {"label": "Catppuccin Frappé", "family": "catppuccin", "flavor": "frappe", "gtk": "catppuccin-frappe-mauve-standard+default", "kvantum": "catppuccin-frappe-mauve", "dark": True},
    "latte": {"label": "Catppuccin Latte", "family": "catppuccin", "flavor": "latte", "gtk": "catppuccin-latte-mauve-standard+default", "kvantum": "catppuccin-latte-mauve", "dark": False},
    "nord": {"label": "Nord", "family": "nord", "flavor": "nord", "gtk": "cachyos-nord", "kvantum": "Nordic-Darker-Solid", "dark": True},
    "rose-pine": {"label": "Rosé Pine Moon", "family": "rose-pine", "flavor": "moon", "gtk": "Rose-Pine-Moon", "kvantum": "rose-pine-moon", "dark": True, "generated": True},
    "tokyo-night": {"label": "Tokyo Night Storm", "family": "tokyo-night", "flavor": "storm", "gtk": "Tokyo-Night-Storm", "kvantum": "tokyo-night-storm", "dark": True, "generated": True},
    "everforest": {"label": "Everforest", "family": "everforest", "flavor": "medium", "gtk": "Everforest-Medium", "kvantum": "everforest-medium", "dark": True, "generated": True},
}


def color(name: str) -> str:
    return "#" + PALETTES[CURRENT][name]


CURRENT = "tokyo-night"


def path(relative: str) -> Path:
    return ROOT / relative


def replace_assignment(text: str, key: str, value: str) -> str:
    pattern = rf"(?m)^(\s*{re.escape(key)}\s*=\s*).*$"
    updated, count = re.subn(pattern, lambda m: m.group(1) + value, text, count=1)
    if not count:
        raise ValueError(f"Could not find config key {key!r}")
    return updated


def replace_section(text: str, section: str, entries: dict[str, str]) -> str:
    match = re.search(rf"(?ms)^\[{re.escape(section)}\]\s*\n(.*?)(?=^\[|\Z)", text)
    if not match:
        raise ValueError(f"Could not find [{section}] section")
    body = match.group(1)
    for key, value in entries.items():
        pattern = rf"(?m)^(\s*{re.escape(key)}\s*=\s*).*$"
        body, count = re.subn(pattern, lambda m: m.group(1) + value, body, count=1)
        if not count:
            body += f"{key}={value}\n"
    return text[:match.start(1)] + body + text[match.end(1):]


def write(relative: str, text: str) -> None:
    path(relative).write_text(text)


def gtk_theme_directory(theme_name: str) -> Path | None:
    for base in (HOME / ".local/share/themes", HOME / ".themes", Path("/usr/share/themes")):
        candidate = base / theme_name
        if candidate.is_dir():
            return candidate
    return None


def kvantum_theme_directory(theme_name: str) -> Path | None:
    for base in (HOME / ".config/Kvantum", HOME / ".local/share/Kvantum", Path("/usr/share/Kvantum")):
        candidate = base / theme_name
        if candidate.is_dir():
            return candidate
    return None


def recolor_theme_tree(source: Path, destination: Path, theme_name: str) -> None:
    marker = destination / ".dotfiles-generated-theme"
    if destination.exists():
        if not marker.is_file():
            raise FileExistsError(f"Refusing to replace existing theme directory: {destination}")
        shutil.rmtree(destination)
    shutil.copytree(source, destination, symlinks=True)

    original_to_new = {
        value.lower(): PALETTES[CURRENT][key]
        for key, value in PALETTES["mocha"].items()
    }
    mocha_theme_extras = {
        "eff1f5": "text",
        "393947": "surface2", "282938": "surface1", "14141f": "crust", "0a0a0f": "crust",
        "333342": "surface1", "242434": "surface0", "35353d": "surface1", "4d4d54": "overlay0",
        "dbc2fa": "lavender", "3d3e4c": "surface2", "d0b1f7": "mauve", "444556": "surface2",
        "e6d5fb": "lavender", "bd8ff5": "mauve", "d9bdf9": "lavender", "cbb0f7": "lavender",
        "b998e3": "mauve", "f9e2a7": "yellow", "f7d997": "yellow", "f17497": "red",
        "f7e6c1": "peach", "b8e7b6": "green", "f2a5bb": "pink",
    }
    original_to_new.update({old: PALETTES[CURRENT][key] for old, key in mocha_theme_extras.items()})
    hex_pattern = re.compile(r"#([0-9a-fA-F]{6})([0-9a-fA-F]{2})?\b")
    for item in destination.rglob("*"):
        if not item.is_file() or item.is_symlink():
            continue
        try:
            content = item.read_text()
        except (UnicodeDecodeError, OSError):
            continue
        content = hex_pattern.sub(
            lambda match: "#"
            + original_to_new.get(match.group(1).lower(), match.group(1))
            + (match.group(2) or ""),
            content,
        )
        if item.name == "index.theme":
            content = re.sub(r"(?m)^Name=.*$", f"Name={theme_name}", content, count=1)
            content = re.sub(r"(?m)^GtkTheme=.*$", f"GtkTheme={theme_name}", content, count=1)
            content = re.sub(r"(?m)^MetacityTheme=.*$", f"MetacityTheme={theme_name}", content, count=1)
        item.write_text(content)

    for item in list(destination.iterdir()):
        if item.is_file() and item.name.startswith("catppuccin-mocha-mauve"):
            renamed = item.with_name(item.name.replace("catppuccin-mocha-mauve", str(theme_name).lower()))
            item.rename(renamed)
    marker.write_text("Generated from the installed Catppuccin Mocha assets by apply_theme.py.\n")


def ensure_generated_theme_assets(theme: dict[str, object]) -> None:
    source_gtk = gtk_theme_directory("catppuccin-mocha-mauve-standard+default")
    source_kvantum = kvantum_theme_directory("catppuccin-mocha-mauve")
    if source_gtk is None or source_kvantum is None:
        raise FileNotFoundError("Install the Catppuccin theme assets before selecting a generated theme")
    recolor_theme_tree(
        source_gtk,
        HOME / ".local/share/themes" / str(theme["gtk"]),
        str(theme["gtk"]),
    )
    recolor_theme_tree(
        source_kvantum,
        HOME / ".config/Kvantum" / str(theme["kvantum"]),
        str(theme["kvantum"]),
    )


def apply_gtk(theme: dict[str, object]) -> None:
    gtk_name = str(theme["gtk"])
    for version in ("gtk-3.0", "gtk-4.0"):
        rel = f"gtk/.config/{version}/settings.ini"
        text = path(rel).read_text()
        text = replace_assignment(text, "gtk-theme-name", gtk_name)
        text = replace_assignment(text, "gtk-application-prefer-dark-theme", "true" if theme["dark"] else "false")
        text = replace_assignment(text, "gtk-cursor-theme-name", "capitaine-cursors")
        write(rel, text)

    css_dir = HOME / ".config/gtk-4.0"
    theme_dir = gtk_theme_directory(gtk_name)
    css_source = (theme_dir / "gtk-4.0") if theme_dir else None
    for name in ("gtk.css", "gtk-dark.css", "assets"):
        link = css_dir / name
        if link.is_symlink():
            link.unlink()
        elif link.exists():
            continue
        target = css_source / name if css_source and (css_source / name).exists() else None
        if target:
            link.symlink_to(target)

    subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "gtk-theme", gtk_name], check=False)
    subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", "prefer-dark" if theme["dark"] else "prefer-light"], check=False)
    subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "cursor-theme", "capitaine-cursors"], check=False)


def apply_palette(theme: dict[str, object]) -> None:
    p = PALETTES[CURRENT]
    foot = path("foot/.config/foot/foot.ini").read_text()
    foot = re.sub(r"(?m)^\[colors\]\s*$", "[colors-dark]", foot, count=1)
    color_mode = "dark" if theme["dark"] else "light"
    if re.search(r"(?m)^initial-color-theme\s*=", foot):
        foot = replace_assignment(foot, "initial-color-theme", color_mode)
    else:
        foot, count = re.subn(r"(?m)^(\[main\]\s*\n)", rf"\1initial-color-theme={color_mode}\n", foot, count=1)
        if not count:
            raise ValueError("Could not find [main] section in Foot config")
    foot_colors = {
        "background": p["base"], "foreground": p["text"],
        "regular0": p["surface1"], "regular1": p["red"], "regular2": p["green"], "regular3": p["yellow"],
        "regular4": p["blue"], "regular5": p["pink"], "regular6": p["teal"], "regular7": p["subtext1"],
        "bright0": p["overlay0"], "bright1": p["red"], "bright2": p["green"], "bright3": p["yellow"],
        "bright4": p["blue"], "bright5": p["pink"], "bright6": p["sky"], "bright7": p["subtext0"],
        "selection-foreground": p["text"], "selection-background": p["surface1"],
    }
    foot_section = "colors-dark" if theme["dark"] else "colors-light"
    if not re.search(rf"(?m)^\[{foot_section}\]\s*$", foot):
        foot += f"\n[{foot_section}]\n"
    foot = replace_section(foot, foot_section, foot_colors)
    write("foot/.config/foot/foot.ini", foot)

    fuzzel = path("fuzzel/.config/fuzzel/fuzzel.ini").read_text()
    fuzzel_colors = {
        "background": p["base"] + "dd", "text": p["text"] + "ff", "prompt": p["subtext1"] + "ff",
        "placeholder": p["overlay1"] + "ff", "input": p["text"] + "ff", "match": p["blue"] + "ff",
        "selection": p["surface1"] + "ff", "selection-text": p["text"] + "ff",
        "selection-match": p["blue"] + "ff", "counter": p["overlay1"] + "ff", "border": p["blue"] + "ff",
    }
    write("fuzzel/.config/fuzzel/fuzzel.ini", replace_section(fuzzel, "colors", fuzzel_colors))

    mako = path("mako/.config/mako/config").read_text()
    mako = replace_assignment(mako, "background-color", color("base"))
    mako = replace_assignment(mako, "text-color", color("text"))
    mako = replace_assignment(mako, "border-color", color("surface1"))
    critical = mako.find("[urgency=critical]")
    if critical >= 0:
        head, tail = mako[:critical], mako[critical:]
        tail = replace_assignment(tail, "background-color", color("red"))
        tail = replace_assignment(tail, "text-color", color("base"))
        tail = replace_assignment(tail, "border-color", color("red"))
        mako = head + tail
    write("mako/.config/mako/config", mako)

    hypr = path("hypr/.config/hypr/hyprland.lua").read_text()
    hypr = re.sub(r'active_border = \{ colors = \{ "rgba\([0-9a-f]+\)", "rgba\([0-9a-f]+\)" \}, angle = 45 \}',
                  f'active_border = {{ colors = {{ "rgba({p["blue"]}ff)", "rgba({p["lavender"]}ff)" }}, angle = 45 }}', hypr, count=1)
    hypr = re.sub(r'inactive_border = "rgba\([0-9a-f]+\)"', f'inactive_border = "rgba({p["surface1"]}aa)"', hypr, count=1)
    write("hypr/.config/hypr/hyprland.lua", hypr)

    decoration = path("hypr/.config/hypr/hyprconf/decoration.lua").read_text()
    decoration = re.sub(r'color = "rgba\([0-9a-f]+\)"', f'color = "rgba({p["crust"]}ee)"', decoration, count=1)
    write("hypr/.config/hypr/hyprconf/decoration.lua", decoration)

    lock = path("hypr/.config/hypr/hyprlock.conf").read_text()
    lock = replace_assignment(lock, "color", f'rgba({rgb(p["base"])}, 1.0)')
    lock = replace_assignment(lock, "outer_color", f'rgba({rgb(p["blue"])}, 0.9)')
    lock = replace_assignment(lock, "inner_color", f'rgba({rgb(p["base"])}, 0.9)')
    lock = replace_assignment(lock, "font_color", f'rgb({rgb(p["text"])})')
    lock = replace_assignment(lock, "check_color", f'rgb({rgb(p["green"])})')
    lock = re.sub(
        r'(?ms)(label \{\n.*?^\s*color = )rgba\([0-9, .]+\)',
        lambda match: match.group(1) + f'rgba({rgb(p["text"])}, 0.75)',
        lock,
    )
    lock = re.sub(r'(?m)^    placeholder_text = .*$', f'    placeholder_text = Enter password', lock)
    write("hypr/.config/hypr/hyprlock.conf", lock)

    calendar = {
        "months": p["text"], "days": p["subtext1"], "weekdays": p["blue"], "today": p["green"],
    }
    waybar_config = path("waybar/.config/waybar/config.jsonc").read_text()
    for key, value in calendar.items():
        pattern = rf"""(?m)(\s*"{key}"\s*:\s*"<span color=['\"]#)[0-9a-fA-F]+"""
        waybar_config, count = re.subn(pattern, rf"\g<1>{value}", waybar_config, count=1)
        if not count:
            raise ValueError(f"Could not find Waybar calendar color for {key!r}")
    write("waybar/.config/waybar/config.jsonc", waybar_config)

    css_palette = {**p, "bluelight": p["blue"]}
    css = "\n".join(f"@define-color {key} #{value};" for key, value in css_palette.items()) + "\n"
    write("waybar/.config/waybar/palette.css", css)
    style = path("waybar/.config/waybar/style.css").read_text()
    style = re.sub(r'@import "[^"]+\.css";', '@import "palette.css";', style, count=1)
    write("waybar/.config/waybar/style.css", style)

    starship_path = "starship/.config/starship.toml"
    starship = path(starship_path).read_text()
    starship = re.sub(r"(?m)^palette\s*=\s*['\"][^'\"]+['\"]", "palette = 'active'", starship, count=1)
    starship = re.sub(r"(?ms)^\[palettes\.active\]\n.*?(?=^\[|\Z)", "", starship)
    starship += "\n[palettes.active]\n"
    for key, value in {
        "dark_blue": p["blue"], "blue": p["blue"], "teal": p["teal"], "red": p["red"],
        "orange": p["peach"], "green": p["green"], "yellow": p["yellow"], "purple": p["mauve"],
        "gray": p["overlay0"], "black": p["crust"], "white": p["text"],
    }.items():
        starship += f"{key} = '#{value}'\n"
    write(starship_path, starship)

    write("nvim/.config/nvim/lua/core/current_theme.lua", f'return {{ id = "{CURRENT}", family = "{theme["family"]}", flavor = "{theme["flavor"]}" }}\n')

    tmux = "\n".join([
        f'set -g status-style "bg=#{p["base"]},fg=#{p["text"]}"',
        f'set -g status-left "#[fg=#{p["base"]},bg=#{p["mauve"]},bold] #S #[default]"',
        f'set -g status-right "#[fg=#{p["subtext1"]},bg=#{p["surface0"]}] %Y-%m-%d %H:%M #[default]"',
        f'set-window-option -g window-status-format "#[fg=#{p["subtext1"]},bg=#{p["base"]}] #I #W "',
        f'set-window-option -g window-status-current-format "#[fg=#{p["base"]},bg=#{p["mauve"]},bold] #I #W "',
        "",
    ])
    write("tmuxcon/.config/tmux/theme.conf", tmux)

    qt = path("qt/.config/Kvantum/kvantum.kvconfig")
    qt.parent.mkdir(parents=True, exist_ok=True)
    qt.write_text(f'[General]\ntheme={theme["kvantum"]}\n')


def rgb(hex_color: str) -> str:
    return ", ".join(str(int(hex_color[i:i+2], 16)) for i in (0, 2, 4))


def reload_apps(theme: dict[str, object]) -> None:
    commands = [
        ["hyprctl", "reload"],
        [str(HOME / ".config/waybar/init.sh")],
        ["makoctl", "reload"],
        ["tmux", "source-file", str(HOME / ".tmux.conf")],
        ["tmux", "source-file", str(HOME / ".config/tmux/theme.conf")],
    ]
    for command in commands:
        try:
            subprocess.run(command, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=False)
        except FileNotFoundError:
            pass
    try:
        subprocess.run(["notify-send", "Theme changed", str(theme["label"])], check=False)
    except FileNotFoundError:
        pass


def main() -> int:
    global CURRENT
    if len(sys.argv) != 2 or sys.argv[1] not in THEMES:
        print("Usage: apply_theme.py {mocha|macchiato|frappe|latte|nord|rose-pine|tokyo-night|everforest}", file=sys.stderr)
        return 2
    CURRENT = sys.argv[1]
    theme = THEMES[CURRENT]
    if theme.get("generated"):
        try:
            ensure_generated_theme_assets(theme)
        except (FileNotFoundError, FileExistsError) as error:
            print(error, file=sys.stderr)
            return 1
    gtk_dir = gtk_theme_directory(str(theme["gtk"]))
    if gtk_dir is None:
        print(f"GTK theme assets are missing: {theme['gtk']}", file=sys.stderr)
        return 1
    if kvantum_theme_directory(str(theme["kvantum"])) is None:
        print(f"Kvantum theme assets are missing: {theme['kvantum']}", file=sys.stderr)
        return 1

    apply_palette(theme)
    apply_gtk(theme)
    state_home = Path(os.environ.get("XDG_STATE_HOME", str(HOME / ".local/state")))
    state_file = state_home / "dotfiles-theme-picker/current-theme"
    try:
        state_file.parent.mkdir(parents=True, exist_ok=True)
        state_file.write_text(CURRENT + "\n")
    except OSError as error:
        print(f"Could not save active theme indicator: {error}", file=sys.stderr)
    reload_apps(theme)
    print(f"Applied {theme['label']}. Restart open GTK/Qt, Foot, and Neovim windows to update them.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
