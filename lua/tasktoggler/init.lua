-- setup module
local M = {}

local checked = "x"
local unchecked = " "

M.setup = function()
	vim.api.nvim_create_user_command("TaskTogglerCheck", function()
		-- get parser of current buffer and parse out the tree
		-- finally get the root of the tree
		local parser = vim.treesitter.get_parser(0, "markdown", {})
		local tree = parser:parse()[1]
		local root = tree:root()

		-- create parsed query for unchecked
		local query = vim.treesitter.query.parse(
			"markdown",
			[[
			(task_list_marker_unchecked) @marker]]
		)

		-- get current line of the cursor to determine which task should be toggled
		local currentLine = unpack(vim.api.nvim_win_get_cursor(0)) - 1

		for _, capture, _ in query:iter_captures(root, line) do
			local row1, col1 = capture:range()

			-- if current line matches the capture row, check task
			if row1 == currentLine then
				vim.api.nvim_buf_set_text(0, row1, col1 + 1, row1, col1 + 2, { checked })
			end
		end
	end, {})
	vim.api.nvim_create_user_command("TaskTogglerUncheck", function() end, {})
	vim.api.nvim_create_user_command("TaskTogglerToggle", function() end, {})
end

return M
