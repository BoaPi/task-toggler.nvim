-- setup module
local M = {}

local checked = "x"
local unchecked = " "

-- parse all queries
local uncheckedQuery = vim.treesitter.query.parse(
	"markdown",
	[[
			(task_list_marker_unchecked) @marker_unchecked]]
)

local checkedQuery = vim.treesitter.query.parse(
	"markdown",
	[[
			(task_list_marker_checked) @marker_checked]]
)

local allTaskQuery = vim.treesitter.query.parse(
	"markdown",
	[[
	(task_list_marker_checked) @marker_checked
	(task_list_marker_unchecked) @marker_unchecked
	]]
)

--- @param is_range boolean
--- @return TSNode, number, number
local getBufferInfo = function(is_range)
	print(vim.cmd("echo mode()"))
	print(vim.api.nvim_get_mode().mode)

	-- get parser of current buffer and parse out the tree
	-- finally get the root of the tree
	local parser = vim.treesitter.get_parser(0, "markdown", {})
	local tree = parser:parse()[1]
	local root = tree:root()

	-- get current line of the cursor to determine which task should be toggled
	-- reduce by "1" to get correct position for later comparison, due to the zero-index based
	-- values of "iter_captures"
	local row_start
	local row_end

	if is_range then
		row_start = vim.api.nvim_buf_get_mark(0, "<")[1]
		row_end = vim.api.nvim_buf_get_mark(0, ">")[1]
	else
		row_start = unpack(vim.api.nvim_win_get_cursor(0)) - 1
	end

	return root, row_start, row_end
end

--- @param root TSNode
--- @param line number
--- @param query Query
--- @param replacement string
local replaceCaptures = function(root, line, query, replacement)
	for _, capture, _ in query:iter_captures(root, line) do
		local row1, col1 = capture:range()

		-- if current line matches the capture row, insert replacement
		-- capture of a task includes " [ ]", therefor +1 and +2 to replace part between brackets
		if row1 == line then
			vim.api.nvim_buf_set_text(0, row1, col1 + 1, row1, col1 + 2, { replacement })
		end
	end
end

M.setup = function()
	vim.api.nvim_create_user_command("TaskTogglerCheck", function()
		local root, currentLine = getBufferInfo()

		replaceCaptures(root, currentLine, uncheckedQuery, checked)
	end, {})

	vim.api.nvim_create_user_command("TaskTogglerUncheck", function()
		local root, currentLine = getBufferInfo()

		replaceCaptures(root, currentLine, checkedQuery, unchecked)
	end, {})

	vim.api.nvim_create_user_command("TaskTogglerToggle", function()
		local test, row_1, row_2 = getBufferInfo(true)
		print(test, row_1, row_2)
	end, {})
end

return M
