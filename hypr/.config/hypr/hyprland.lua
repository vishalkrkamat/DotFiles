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

-- Keep the three standard workspaces visible and persistent on any display.
for workspace = 1, 3 do
	hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end

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
			active_border = { colors = { "rgba(89b4faff)", "rgba(b4befeff)" }, angle = 45 },
			inactive_border = "rgba(45475aaa)",
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
	hl.exec_cmd("waybar")
	hl.exec_cmd("swaybg -i ~/Pictures/Wallpapers/wall5.png -m fill")
	hl.exec_cmd("~/.config/script/bright.sh")
end)
