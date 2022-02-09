local M = {}

local generic_opts_any = { noremap = true, silent = true }

local generic_opts = {
	insert_mode = generic_opts_any,
	normal_mode = generic_opts_any,
	visual_mode = generic_opts_any,
	visual_block_mode = generic_opts_any,
	command_mode = generic_opts_any,
	term_mode = { silent = true },
}

local mode_adapters = {
	insert_mode = "i",
	normal_mode = "n",
	term_mode = "t",
	visual_mode = "v",
	visual_block_mode = "x",
	command_mode = "c",
}

local defaults = {
	insert_mode = {
		["kj"] = "<ESC>", -- alternative escape
		["<C-j>"] = "<ESC>:m .+1<CR>==li", -- move line down
		["<C-k>"] = "<ESC>:m .-2<CR>==li", -- move line up
		--undo breakpoints
		[","] = ",<C-g>u",
		["."] = ".<C-g>u",
		["`"] = "`<C-g>u",
		[";"] = ";<C-g>u",
		["!"] = "!<C-g>u",
		["?"] = "?<C-g>u",
		["{"] = "{<C-g>u",
		["}"] = "}<C-g>u",
		["("] = "(<C-g>u",
		[")"] = ")<C-g>u",
		["["] = "[<C-g>u",
		["]"] = "]<C-g>u"
	},
	normal_mode = {
		["<SPACE>"] = "<NOP>", -- remap space to nothing
		["<C-j>"] = ":m .+1<CR>==", -- move line down
		["<C-k>"] = ":m .-2<CR>==", -- move line up
		["sa"] = "ggVG" -- select all
	},
	visual_mode = {
		["<C-j>"] = ":m '>+1<CR>gv=gv", -- move line down
		["<C-k>"] = ":m '<-2<CR>gv=gv", -- move line up
		-- better indenting
		["<"] = "<gv",
		[">"] = ">gv"
	}
}

if vim.fn.has "mac" == 1 then
	defaults.normal_mode["<A-Up>"] = defaults.normal_mode["<C-Up>"]
	defaults.normal_mode["<A-Down>"] = defaults.normal_mode["<C-Down>"]
	defaults.normal_mode["<A-Left>"] = defaults.normal_mode["<C-Left>"]
	defaults.normal_mode["<A-Right>"] = defaults.normal_mode["<C-Right>"]
	print "Activated mac keymappings"
end

function M:set_keymaps(mode, key, val)
	local opt = generic_opts[mode] and generic_opts[mode] or generic_opts_any
	if type(val) == "table" then
		opt = val[2]
		val = val[1]
	end
	vim.api.nvim_set_keymap(mode, key, val, opt)
end

function M:load_mode(mode, keymaps)
	mode = mode_adapters[mode] and mode_adapters[mode] or mode
	for k, v in pairs(keymaps) do
		M:set_keymaps(mode, k, v)
	end
end

function M:load()
	for mode, mapping in pairs(defaults) do
		M:load_mode(mode, mapping)
	end
end

return M
