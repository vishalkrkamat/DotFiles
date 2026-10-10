local parsers = {
	"bash",
	"c",
	"diff",
	"html",
	"css",
	"scss",
	"javascript",
	"jsdoc",
	"json",
	"rust",
	"lua",
	"luadoc",
	"luap",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"xml",
	"yaml",
}

local function setup_textobject_motions()
	require("nvim-treesitter-textobjects").setup({ move = { set_jumps = true } })
	local move = require("nvim-treesitter-textobjects.move")
	local modes = { "n", "x", "o" }
	local motions = {
		["]f"] = { move.goto_next_start, "@function.outer" },
		["]c"] = { move.goto_next_start, "@class.outer" },
		["]a"] = { move.goto_next_start, "@parameter.inner" },
		["]F"] = { move.goto_next_end, "@function.outer" },
		["]C"] = { move.goto_next_end, "@class.outer" },
		["]A"] = { move.goto_next_end, "@parameter.inner" },
		["[f"] = { move.goto_previous_start, "@function.outer" },
		["[c"] = { move.goto_previous_start, "@class.outer" },
		["[a"] = { move.goto_previous_start, "@parameter.inner" },
		["[F"] = { move.goto_previous_end, "@function.outer" },
		["[C"] = { move.goto_previous_end, "@class.outer" },
		["[A"] = { move.goto_previous_end, "@parameter.inner" },
	}

	for key, motion in pairs(motions) do
		vim.keymap.set(modes, key, function()
			motion[1](motion[2], "textobjects")
		end, { desc = "Treesitter: " .. key .. " text object" })
	end
end

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	dependencies = {
		{ "nvim-treesitter/nvim-treesitter-textobjects", branch = "main" },
	},
	config = function()
		require("nvim-treesitter").setup()
		vim.treesitter.language.register("json", "jsonc")
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				if pcall(vim.treesitter.start, args.buf) then
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})

		setup_textobject_motions()
		require("treesitter_selection").setup()
	end,
}
