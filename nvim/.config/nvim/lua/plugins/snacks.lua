return {
	"folke/snacks.nvim",
	-- @type snacks.Config
	opts = {
		bigfile = { enabled = true },
		indent = {
			priority = 1,
			enabled = true,
			char = "│",
			highlight = "IndentBlanklineChar",
			scope = {
				enabled = true,
				char = "┃",
				highlight = "IndentBlanklineScope",
			},
		},
		notifier = {
			enabled = true,
			top_down = true,
		},
		input = {
			enabled = true,
			default_prompt = "> ",
			border = "rounded",
		},
		statuscolumn = { enabled = true },
		terminal = { enabled = true },
		words = { enabled = true },
		picker = { enabled = true, hidden = true },
		quickfile = { enabled = true },
		explorer = { enabled = true },
		scroll = {
			animate = {
				duration = { step = 10, total = 200 },
				easing = "outQuad", -- Modern easing function (requires easing support)
			},
			toggle = {
				which_key = true, -- integrate with which-key to show enabled/disabled icons and colors
				notify = true, -- show a notification when toggling
				-- icons for enabled/disabled states
				icon = {
					enabled = " ",
					disabled = " ",
				},
				-- colors for enabled/disabled states
				color = {
					enabled = "green",
					disabled = "yellow",
				},
			},
			-- faster animation when repeating scroll after delay
			animate_repeat = {
				delay = 80, -- delay in ms before using the repeat animation
				duration = { step = 5, total = 40 },
				easing = "outQuad", -- Modern easing function (requires easing support)
			},
			-- what buffers to animate
			filter = function(buf)
				return vim.g.snacks_scroll ~= false
					and vim.b[buf].snacks_scroll ~= false
					and vim.bo[buf].buftype ~= "terminal"
			end,
		},
	},
}
