local M = {}

M.config = function()
	local nvim_comment = {
		enable = true,
		marker_adding = true, -- comment and line should have whitespace between them
		comment_empty = false, -- should not comment out empty lines
		create_mappings = true, -- create keymappin
	}
	require("nvim_comment"):setup(nvim_comment)
end

return M
