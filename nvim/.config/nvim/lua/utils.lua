local M = {}

function M.get_root(buf)
	buf = buf or 0
	local path = vim.api.nvim_buf_get_name(buf)
	path = path ~= "" and vim.fs.dirname(path) or vim.loop.cwd()

	-- Language/project-specific root indicators
	local root_patterns = {
		-- Git and common project markers
		".git",
		".hg",
		".svn",

		-- Node / JS / TS
		"package.json",
		"tsconfig.json",
		"jsconfig.json",
		"yarn.lock",
		"pnpm-lock.yaml",

		-- Python
		"pyproject.toml",
		"requirements.txt",
		"setup.py",
		"setup.cfg",

		-- Rust
		"Cargo.toml",

		-- Go
		"go.mod",

		-- Zig
		"build.zig",
		"build.zig.zon",

		-- C/C++
		"Makefile",
		"CMakeLists.txt",
		"meson.build",

		-- Java
		"pom.xml",
		"build.gradle",

		-- Lua
		"init.lua",
		"lua",

		-- Deno
		"deno.json",
		"deno.jsonc",

		-- Elixir
		"mix.exs",

		-- Haskell
		"stack.yaml",
		"cabal.project",

		-- Other common build files
		".nvim-root", -- custom fallback marker
	}

	local root = vim.fs.find(root_patterns, {
		path = path,
		upward = true,
		stop = vim.loop.os_homedir(),
		type = "file",
	})[1]

	return root and vim.fs.dirname(root) or vim.loop.cwd()
end

return M
