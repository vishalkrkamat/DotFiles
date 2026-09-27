-- Hyprland Lua configuration (Hyprland 0.55+).
-- Keep the existing modular organization while using native Lua modules.

local terminal = "foot"
local file_manager = "thunar"
local menu = "fuzzel"

hl.monitor({
	output = "eDP-1",
	mode = "1920x1080@144",
	position = "0x0",
	scale = 1,
})

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
			active_border = { colors = { "rgba(00caffff)", "rgba(5e81acff)" }, angle = 45 },
			inactive_border = "rgba(4c566add)",
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
	-- Keep the original silent workspace placement for startup applications.
	hl.exec_cmd([[hyprctl dispatch exec '[workspace 1 silent] zen-browser']])
	hl.exec_cmd([[hyprctl dispatch exec '[workspace 2 silent] ]] .. terminal .. [[']])
	hl.exec_cmd("waybar")
	hl.exec_cmd("hyprpaper")
	hl.exec_cmd("~/.config/script/bright.sh")
end)
