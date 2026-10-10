local M = {}
local selections = {}

local function select_node(buf, node)
	local start_row, start_col, end_row, end_col = node:range()
	if end_row > start_row and end_col == 0 then
		end_row = end_row - 1
		local final_line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, false)[1] or ""
		end_col = #final_line
	else
		end_col = math.max(start_col, end_col - 1)
	end

	vim.api.nvim_buf_set_mark(buf, "<", start_row, start_col, {})
	vim.api.nvim_buf_set_mark(buf, ">", end_row, end_col, {})
	vim.cmd.normal({ bang = true, args = { "gv" } })
end

local function expand_selection()
	local buf = vim.api.nvim_get_current_buf()
	local state = selections[buf]
	local in_visual_mode = vim.fn.mode(1):match("^[vV\22]") ~= nil

	if not state or not in_visual_mode then
		local node = vim.treesitter.get_node({ bufnr = buf })
		if not node then
			return
		end
		state = { node }
		selections[buf] = state
	else
		local parent = state[#state]:parent()
		if not parent then
			return
		end
		state[#state + 1] = parent
	end

	select_node(buf, state[#state])
end

local function shrink_selection()
	local buf = vim.api.nvim_get_current_buf()
	local state = selections[buf]
	if not state or #state <= 1 then
		return
	end
	table.remove(state)
	select_node(buf, state[#state])
end

function M.setup()
	vim.keymap.set({ "n", "x" }, "<C-space>", expand_selection, { desc = "Expand Treesitter selection" })
	vim.keymap.set("x", "<BS>", shrink_selection, { desc = "Shrink Treesitter selection" })
	vim.api.nvim_create_autocmd("BufWipeout", {
		callback = function(args)
			selections[args.buf] = nil
		end,
	})
end

return M
