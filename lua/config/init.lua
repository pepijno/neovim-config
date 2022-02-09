local utils = require "utils"
local M = {}

function M:load()
	require("keymappings"):load()
	require("config.settings"):load_options()

	local autocmds = require "core.autocmds"
	autocmds.define_augroups(autocmds.autocommands)

--	local lvim_lsp_config = require "lvim.lsp.config"
--	lvim.lsp = apply_defaults(lvim.lsp, vim.deepcopy(lvim_lsp_config))

	require("lsp.manager").init_defaults()

	vim.g.mapleader = " "

--	local autocmds = require "lvim.core.autocmds"
--	autocmds.configure_format_on_save()

	local plugins = require "plugins"
	local plugin_loader = require "plugin-loader"
	plugin_loader:cache_clear()
	plugin_loader:load(plugins)
	vim.cmd ":PackerInstall"
	-- vim.cmd ":PackerCompile"
--	vim.cmd ":PackerClean"

	require("core"):config()
	require("lsp"):setup()
--	print "Reloaded configuration"
end

return M
