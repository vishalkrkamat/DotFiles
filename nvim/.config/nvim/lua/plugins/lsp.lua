return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"saghen/blink.cmp",
	},
	event = { "BufReadPre", "BufNewFile" }, -- Lazy load on buffer events
	opts = {
		inlay_hints = {
			enabled = true,
			exclude = { "vue", "c" }, -- Filetypes for which inlay hints are disabled
		},
		codelens = {
			enabled = true,
		},
	},
	config = function(_, opts)
		-- Setup mason.nvim for managing LSP servers
		require("mason").setup({
			ui = {
				border = "rounded",
				icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
			},
		})

		-- Setup mason-lspconfig to automatically install LSP servers
		require("mason-lspconfig").setup({
			ensure_installed = {
				"lua_ls",
				"pyright",
				"clangd",

				-- web
				"html",
				"cssls",
				"ts_ls",
				"eslint",
				"jsonls",
				"emmet_language_server",
			},
			automatic_installation = true,
		})

		-- Get LSP capabilities from blink.cmp
		local capabilities = require("blink.cmp").get_lsp_capabilities()

		if vim.fn.has("nvim-0.10") == 1 and opts.inlay_hints.enabled then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buffer = args.buf
					if
						client
						and client:supports_method("textDocument/inlayHint")
						and vim.api.nvim_buf_is_valid(buffer)
						and vim.bo[buffer].buftype == ""
						and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
					then
						vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
					end
				end,
			})
		end

		-- Enable CodeLens
		if vim.fn.has("nvim-0.10") == 1 and opts.codelens.enabled and vim.lsp.codelens then
			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local client = vim.lsp.get_client_by_id(args.data.client_id)
					local buffer = args.buf
					if client and client:supports_method("textDocument/codeLens") then
						vim.lsp.codelens.refresh({ bufnr = buffer })
						vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
							buffer = buffer,
							callback = function()
								vim.lsp.codelens.refresh({ bufnr = buffer })
							end,
						})
					end
				end,
			})
		end

		-- Define LSP server configurations
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						workspace = { checkThirdParty = false },
						diagnostics = { globals = { "vim" } },
						hint = { enable = true },
						codeLens = { enable = false }, -- Enable CodeLens for lua_ls
					},
				},
			},
			pyright = {},
			rust_analyzer = {
				cmd = { "rust-analyzer" }, -- <- will use the rustup-provided one
				settings = {
					["rust-analyzer"] = {
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			},
			clangd = {
				cmd = {
					"clangd",
					"--background-index",
					"--clang-tidy",
					"--completion-style=detailed",
					"--header-insertion=never",
				},
				init_options = {
					clangdFileStatus = true,
				},
			},

			-- web
			html = {},
			cssls = {},
			ts_ls = {},
			eslint = {},
			jsonls = {},
			tailwindcss = {},

			emmet_language_server = {
				filetypes = {
					"css",
					"html",
					"javascriptreact",
					"typescriptreact",
					"less",
					"sass",
					"scss",
				},
				init_options = {
					preferences = {},
					showAbbreviationSuggestions = true,
					showExpandedAbbreviation = "always",
					showSuggestionsAsSnippets = false,
					syntaxProfiles = {},
					variables = {},
				},
			},
		}

		-- Setup each LSP server with capabilities and on_attach
		-- local lspconfig = require("lspconfig")
		for server, config in pairs(servers) do
			config.capabilities = capabilities
			vim.lsp.config(server, config)
			vim.lsp.enable(server)
		end

		-- Configure diagnostics UI
		vim.diagnostic.config({
			virtual_text = {
				prefix = "●",
			},
			severity_sort = true,
			underline = true,
			update_in_insert = false,
			float = { border = "rounded" },
			signs = true,
		})
	end,
}
