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
--- @param range_start number
--- @param range_end number
--- @param query Query
--- @param replacement string
local replaceCaptures = function(root, range_start, range_end, query, replacement)
	for _, capture, _ in query:iter_captures(root, range_start) do
		local row1, col1, _, col2 = capture:range()

		-- extracted row and col are zero indexed, therefor +1 is added
		-- afterwards for better comparison with range_start and range_end, which
		-- are NOT zero indexed
		-- if current line matches the capture row, insert replacement
		-- capture of a task includes " [ ]", therefor + 1 needs to be added  to replace part between brackets
		if row1 + 1 >= range_start and row1 + 1 <= range_end then
			vim.api.nvim_buf_set_text(0, row1, col1 + 1, row1, col2 - 1, { replacement })
		end
	end
end

M.setup = function()
	vim.api.nvim_create_user_command("TaskTogglerCheck", function()
		local root, range_start, range_end = getBufferInfo()

		replaceCaptures(root, range_start, range_end, uncheckedQuery, checked)
	end, {})

	vim.api.nvim_create_user_command("TaskTogglerUncheck", function()
		local root, range_start, range_end = getBufferInfo()

		replaceCaptures(root, range_start, range_end, checkedQuery, unchecked)
	end, {})

	vim.api.nvim_create_user_command("TaskTogglerToggle", function() end, {})
end

return M
