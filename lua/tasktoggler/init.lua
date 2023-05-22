-- setup module
local M = {}

M.setup = function()
	print("setup is working")

	vim.api.nvim_create_user_command("TaskTogglerCheck", function() end, {})
	vim.api.nvim_create_user_command("TaskTogglerUncheck", function() end, {})
	vim.api.nvim_create_user_command("TaskTogglerToggle", function() end, {})
end

return M

-- ToggleToDo
-- function to check or un-check a To-Do in .md filesystem
--vim.api.nvim_create_user_command("ToggleToDo", function()
--local line = vim.api.nvim_get_current_line()
--local newLine
--
---- pattern to match start of a to-do with "*" or "-"
--local checkPattern = "(%s*[%*|%-] )%[[x]%](.*)"
--local unCheckPattern = "(%s*[%*|%-] )%[[%s]%](.*)"
--
---- create matches for each pattern
--local matchCheck = string.match(line, checkPattern)
--local matchUnCheck = string.match(line, unCheckPattern)
--
---- if one pattern matches replace line with new state
--if matchCheck then
--newLine = string.gsub(line, checkPattern, "%1[ ]%2")
--elseif matchUnCheck then
--newLine = string.gsub(line, unCheckPattern, "%1[x]%2")
--end
--
---- replace line with new toggled line
--vim.api.nvim_set_current_line(newLine)
--end, {})
