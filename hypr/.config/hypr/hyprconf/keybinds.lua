-- Converted from keybinds.conf.
local terminal = "foot"
local file_manager = "thunar"
local menu = "fuzzel"
local mod = "ALT"

hl.bind(mod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mod .. " + X", hl.dsp.window.close())
hl.bind(mod .. " + F", hl.dsp.window.fullscreen())

hl.bind(mod .. " + BackSpace", hl.dsp.exec_cmd([[zsh -c '
if ~/.config/script/get_state.sh; then
    hyprctl dispatch exit
else
    hyprctl notify -0 10000 "rgb(ff1ea3)" "Press again to exit"
    sleep 10 && rm -f /tmp/exit.lock
fi']]))

hl.bind(mod .. " + M", hl.dsp.exec_cmd(file_manager))
hl.bind(mod .. " + V", hl.dsp.window.float())
hl.bind(mod .. " + S", hl.dsp.exec_cmd(menu))
hl.bind(mod .. " + P", hl.dsp.window.pseudo())
hl.bind(mod .. " + SHIFT + Q", hl.dsp.exec_cmd("hyprlock"))

-- Region recording; long-running work remains in a child shell process.
hl.bind(mod .. " + SHIFT + X", hl.dsp.exec_cmd([[
pkill -INT wf-recorder 2>/dev/null || true
SEL="$(slurp)" || exit
[ -n "$SEL" ] || exit
DIR="$HOME/Videos/Recording"
mkdir -p "$DIR"
FILE="$DIR/recording_$(date +%F_%H-%M-%S).mp4"
notify-send "🎥 Recording started"
wf-recorder --codec libx264 --pixel-format yuv420p --framerate 60 --file-type mp4 --args "-b:v 20M" -g "$SEL" -f "$FILE" &&
notify-send "✅ Recording saved" "$(basename "$FILE")"
]]))
hl.bind(mod .. " + SHIFT + C", hl.dsp.exec_cmd("pkill -INT wf-recorder && notify-send '🛑 Recording stopped' -t 1500"))

hl.bind(mod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mod .. " + L", hl.dsp.focus({ direction = "right" }))

for key, workspace in pairs({
    ["1"] = 1, ["2"] = 2, ["3"] = 3, ["4"] = 4, ["5"] = 5,
    ["6"] = 6, ["7"] = 7, ["8"] = 8, ["9"] = 9, ["0"] = 10,
}) do
    hl.bind(mod .. " + " .. key, hl.dsp.focus({ workspace = workspace }))
    hl.bind(mod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = workspace, follow = false }))
end

hl.bind(mod .. " + D", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mod .. " + SHIFT + D", hl.dsp.window.move({ workspace = "special:magic", follow = false }))
hl.bind(mod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mod .. " + mouse_up", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
