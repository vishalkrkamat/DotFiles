local current_theme = require("core.current_theme")

return {
	"catppuccin/nvim",
	lazy = false,
	priority = 1000,
	name = "catppuccin",
	opts = {
		flavour = current_theme.family == "catppuccin" and current_theme.flavor or "mocha",
		integrations = {
			aerial = true,
			alpha = true,
			cmp = true,
			dashboard = true,
			flash = true,
			fzf = true,
			grug_far = true,
			gitsigns = true,
			headlines = true,
			illuminate = true,
			indent_blankline = { enabled = true },
			leap = true,
			lsp_trouble = true,
			mason = true,
			markdown = true,
			mini = true,
			native_lsp = {
				enabled = true,
				underlines = {
					errors = { "undercurl" },
					hints = { "undercurl" },
					warnings = { "undercurl" },
					information = { "undercurl" },
				},
			},
			navic = { enabled = true, custom_bg = "lualine" },
			neotest = true,
			neotree = true,
			noice = true,
			notify = true,
			semantic_tokens = true,
			snacks = true,
			telescope = true,
			treesitter = true,
			treesitter_context = true,
			which_key = true,
		},
	},
	specs = {
		{
			"akinsho/bufferline.nvim",
			optional = true,
			opts = function(_, opts)
				if (vim.g.colors_name or ""):find("catppuccin") then
					opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
				end
			end,
		},
	},
	config = function()
		if current_theme.family == "nord" then
			require("lazy").load({ plugins = { "nightfox.nvim" } })
			vim.cmd.colorscheme("nordfox")
		elseif current_theme.family == "rose-pine" then
			require("lazy").load({ plugins = { "rose-pine" } })
			vim.cmd.colorscheme("rose-pine-moon")
		elseif current_theme.family == "tokyo-night" then
			require("lazy").load({ plugins = { "tokyonight.nvim" } })
			vim.cmd.colorscheme("tokyonight-storm")
		elseif current_theme.family == "everforest" then
			vim.g.everforest_background = "medium"
			require("lazy").load({ plugins = { "everforest" } })
			vim.cmd.colorscheme("everforest")
		else
			vim.cmd.colorscheme("catppuccin")
		end
	end,
}
