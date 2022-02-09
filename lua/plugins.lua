return {
	{ "wbthomason/packer.nvim", opt = true },

	-- Icons
	{ "kyazdani42/nvim-web-devicons" },

	-- Color scheme
	{ "morhetz/gruvbox" },

	-- Comments
	{
		"terrortylor/nvim-comment",
		event = "BufRead",
	},

	-- Telescope
	{ "nvim-lua/plenary.nvim" },
	{ "nvim-lua/popup.nvim" },
	{ "nvim-telescope/telescope.nvim" },

	-- Which-Key
	{ "folke/which-key.nvim" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	},
	{ "nvim-treesitter/playground" },

	-- Autopairs
	{
		"windwp/nvim-autopairs",
		-- event = "InsertEnter",
		-- after = "nvim-compe",
		config = function()
			require("core.autopairs").setup()
		end,
	},

	-- lualine
	{ "nvim-lualine/lualine.nvim" },
	-- Barbar
	{
		"romgrk/barbar.nvim",
		event = "BufWinEnter",
	},

	-- NvimTree
	{ "kyazdani42/nvim-tree.lua", },

	-- lsp
	{ "williamboman/nvim-lsp-installer", },
	{ "neovim/nvim-lspconfig", },
	{ "tamago324/nlsp-settings.nvim", },
	{
		"folke/lsp-colors.nvim",
		config = function()
			require("lsp-colors").setup()
		end,
	},

	-- null-ls
	{ "jose-elias-alvarez/null-ls.nvim", },
}
