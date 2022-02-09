local M = {}

local builtins = {
	"core.gruvbox",
	"core.nvim-comment",
	"core.telescope",
	"core.treesitter",
	"core.autopairs",
	"core.lualine",
	"core.barbar",
	"core.nvim-tree",
	"core.which-key",
}

function M:config(config)
	for _, builtin_path in ipairs(builtins) do
		local builtin = require(builtin_path)
		builtin.config(config)
	end
end

return M
