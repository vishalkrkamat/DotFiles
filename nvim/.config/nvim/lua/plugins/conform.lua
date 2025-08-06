return {
	"stevearc/conform.nvim",
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	-- This will provide type hinting with LuaLS
	---@module "conform"
	---@type conform.setupOpts
	opts = {
		-- Define your formatters
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "isort", "black" },
			javascript = { "prettierd", "prettier", stop_after_first = true },
			html = { "prettierd", "prettier", stop_after_first = true },
			css = { "prettierd", "prettier", stop_after_first = true },
			markdown = { "prettierd", "prettier", stop_after_first = true },
			htmldjango = { "djlint" },
		},
		-- Set default options
		default_format_opts = {
			lsp_format = "fallback",
		},
		-- Set up format-on-save
		format_on_save = { timeout_ms = 500 },
		-- Customize formatters
		formatters = {
			shfmt = {
				prepend_args = { "-i", "2" },
			},
			prettier = {
				-- Smart conditional options
				prepend_args = function(_, ctx)
					if ctx.filename:match("%.md$") then
						return {
							"--tab-width",
							"4", -- common for Markdown
							"--prose-wrap",
							"always", -- wrap long lines
							"--print-width",
							"140", -- readable line width
						}
					end
					return {
						"--tab-width",
						"4",
						"--print-width",
						"100",
					}
				end,
			},
			djlint = {
				command = "djlint",
				args = {
					"--reformat",
					"-",
					"--indent",
					"4",
				},
				stdin = true,
			},
		},
	},
	init = function()
		-- If you want the formatexpr, here is the place to set it
		vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
	end,
}
