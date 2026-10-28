-- Hyprland Lua configuration (Hyprland 0.55+).
-- Keep the existing modular organization while using native Lua modules.

local terminal = "foot"
local file_manager = "thunar"
local menu = "fuzzel"

hl.monitor({
	output = "",
	mode = "1920x1080@144",
	position = "auto",
	scale = 1,
})

-- Keep standard workspaces visible and use the same icons as the old Waybar.
local workspace_icons = {
	[1] = "",
	[2] = "",
	[3] = "",
	[8] = "",
}
for workspace = 1, 3 do
	hl.workspace_rule({ workspace = tostring(workspace), persistent = true, default_name = workspace_icons[workspace] })
	hl.dispatch(hl.dsp.workspace.rename({ workspace = workspace, name = workspace_icons[workspace] }))
end
hl.workspace_rule({ workspace = "8", default_name = workspace_icons[8] })

require("hyprconf/env")
require("hyprconf/animation")
require("hyprconf/decoration")
require("hyprconf/input")
require("hyprconf/keybinds")

hl.config({
	general = {
		gaps_in = 0,
		gaps_out = 0,
		border_size = 1,
		col = {
			active_border = { colors = { "rgba(7aa2f7ff)", "rgba(bb9af7ff)" }, angle = 45 },
			inactive_border = "rgba(3b4261aa)",
		},
		resize_on_border = false,
		allow_tearing = false,
		layout = "dwindle",
	},
	dwindle = {
		preserve_split = true,
	},
	master = {
		new_status = "slave",
	},
	misc = {
		force_default_wallpaper = 0,
		disable_hyprland_logo = false,
	},
})

hl.on("hyprland.start", function()
	-- Start each application silently on its assigned workspace.
	hl.exec_cmd("zen-browser", { workspace = "1 silent" })
	hl.exec_cmd(terminal, { workspace = "2 silent" })
	-- Prefer Noctalia when installed; otherwise retain the current session tools.
	hl.exec_cmd([[if command -v noctalia >/dev/null 2>&1; then noctalia; else waybar; swaybg -i ~/Pictures/Wallpapers/wall5.png -m fill; fi]])
	hl.exec_cmd("~/.config/script/bright.sh")
end)
