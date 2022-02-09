local utils = require "utils"

local M = {}

local defaults = {
	fileencoding                                 = "utf-8", -- set file encoding
	mouse                                        = "a", -- enable mouse
	relativenumber                               = true, -- set relative line numbers
	number                                       = true, -- set current line number
	hlsearch                                     = true, -- highlight when searched
	incsearch                                    = true, -- set incremental search
	ignorecase                                   = true, -- ingore cases when searching
	smartcase                                    = true, -- enable smart cases
	hidden                                       = true, -- keep multiple files with unsaved changes open
	-- noerrorbells                              = true, -- remove error bells
	signcolumn                                   = "yes", -- always show the sign column
	colorcolumn                                  = "80", -- set the color column
	cursorline                                   = true, -- highlight current line
	cmdheight                                    = 2, -- set command prompt height
	wrap                                         = false, -- disable text wrapping
	scrolloff                                    = 999, -- set scrolloff large, puts current line in the middle
	sidescrolloff                                = 8, -- set side scrolloff
	pumheight                                    = 10, -- pop up menu height
	showmode                                     = false, -- don't show stuff like -- INSERT --
	termguicolors                                = true, -- set colors in terminals
	timeoutlen                                   = 300, -- the timeout for a mapped sequence
	completeopt                                  = { "menuone", "noselect", }, -- something to do with completion
	-- title                                     = true,
	updatetime                                   = 300, -- faster completion

	-- foldmethod                                = "expr", -- use treesitter based folding
	-- foldexpr                                  = "nvim_treesitter#foldexpr()", -- use treesitter based folding

	tabstop                                      = 4, -- insert 4 spaces for a tab
	shiftwidth                                   = 4, -- use 4 spaces for << en >>
	expandtab                                    = false, -- use tab character instead of spaces for tabs

	swapfile                                     = false, -- no swap files
	backup                                       = false, -- no backup files
	undodir                                      = utils.get_cache_path() .. "/undo", -- set undo directory
	undofile                                     = true, -- enable undo files

	list                                         = true, -- enable showing special characters
	showbreak                                    = "↪\\", -- show line breaks
	listchars                                    = "eol:↵,tab:>-,nbsp:␣,trail:•,extends:>,precedes:<", -- set visibility of whitespaces
	shadafile                                    = utils.get_cache_path() .. "/lvim.shada"
}

function M.load_options()
	for k, v in pairs(defaults) do
		vim.opt[k] = v
	end
end

return M
