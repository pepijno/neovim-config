local M = {}

function M.config()
	conf.nvimtree = {
		nvim_tree_active = true,
		nvim_tree_on_config_done = nil,
		nvim_tree_side = "left",
		nvim_tree_width = 30,
		nvim_tree_show_icons = {
			git = 1,
			folders = 1,
			files = 1,
			folder_arrows = 1,
			tree_width = 30,
		},
		open_on_setup = 1,
		auto_close = 1,
		nvim_tree_quit_on_open = 0,
		update_focused_file = {
			enable = 1,
		},
		filters = {
			dotfiles = 1,
			custom = { ".git", ".cache" },
		},
		nvim_tree_git_hl = 1,
		nvim_tree_root_folder_modifier = ":t",
		open_on_tab = 0,
		nvim_tree_allow_resize = 1,
		lsp_diagnostics = 1,
		nvim_tree_auto_ignore_ft = { "startify", "dashboard" },
		nvim_tree_icons = {
			default = "",
			symlink = "",
			git = {
				unstaged = "✗",
				staged = "✓",
				unmerged = "",
				renamed = "➜",
				deleted = "",
				untracked = "★",
				ignored = "◌",
			},
			folder = {
				arrow_open = "",
				arrow_closed = "",
				default = "",
				open = "",
				empty = "",
				empty_open = "",
				symlink = "",
				symlink_open = "",
			},
			lsp = {
				hint = "",
				info = "",
				warning = "",
				error = "",
			}
		},
	}

	local nvim_tree_config = require "nvim-tree.config"

	for opt, val in pairs(conf.nvimtree) do
		vim.g[opt] = val
	end

	vim.g.update_cwd = 1
	vim.g.nvim_tree_respect_buf_cwd = 1

	local tree_cb = nvim_tree_config.nvim_tree_callback

	local tree_view = require "nvim-tree.view"

	-- Add nvim_tree open callback
	local open = tree_view.open
	tree_view.open = function()
		M.on_open()
		open()
	end

	vim.cmd "au WinClosed * lua require('core.nvim-tree').on_close()"

	require'nvim-tree'.setup {}
end

function M.on_open()
	if package.loaded["bufferline.state"] and conf.nvimtree.side == "left" then
		require("bufferline.state").set_offset(conf.nvimtree.width + 1, "")
	end
end


function M.on_close()
	local buf = tonumber(vim.fn.expand "<abuf>")
	local ft = vim.api.nvim_buf_get_option(buf, "filetype")
	if ft == "NvimTree" and package.loaded["bufferline.state"] then
		require("bufferline.state").set_offset(0)
	end
end

function M.change_tree_dir(dir)
	local lib = require "nvim-tree.lib"
	lib.change_dir(dir)
end

return M
