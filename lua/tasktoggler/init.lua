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

--- @return TSNode root document to look for treesitter captures
--- @return number range_start marks the start row of the selection
--- @return number range_end marks the end row of the selection
local getBufferInfo = function()
	-- get parser of current buffer and parse out the tree
	-- finally get the root of the tree
	local parser = vim.treesitter.get_parser(0, "markdown", {})
	local tree = parser:parse()[1]
	local root = tree:root()
	local range_start = vim.fn.getpos("v")[2]
	local range_end = vim.fn.getpos(".")[2]

	-- make sure range_start is always smaller than range_end
	if range_end < range_start then
		local tmp = range_start
		range_start = range_end
		range_end = tmp
	end

	return root, range_start, range_end
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
		local test, row_1, row_2 = getBufferInfo()
		print(test, row_1, row_2)
	end, {})
end

return M
