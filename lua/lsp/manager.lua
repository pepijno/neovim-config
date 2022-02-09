local M = {}

local function is_client_active(name)
	local clients = vim.lsp.get_active_clients()
	for _, entry in pairs(clients) do
		if entry.name == name then
			return entry
		end
	end
	return nil
end

local config = require "lsp.config"

function M.init_defaults()
	local languages = {
		"asm",
		"bash",
		"c",
		"cpp",
		"fish",
		"haskell",
		"java",
		"json",
		"kotlin",
		"lua",
		"markdown",
		"nix",
		"query",
		"regex",
		"rust",
		"sh",
		"sql",
		"vim",
		"yaml",
	}
	for _, entry in ipairs(languages) do
		if conf.lang[entry] then
			conf.lang[entry] = {
				formatters = {},
				linters = {},
				lsp = {},
			}
		end
	end
end

local function resolve_config()
	local conf = {
		on_attach = require("lsp").common_on_attach,
		on_init = require("lsp").common_on_init,
		capabilities = require("lsp").common_capabilities(),
	}
	return conf
end

-- manually start the server and don't wait for the usual filetype trigger from lspconfig
local function buf_try_add(server_name, bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	require("lspconfig")[server_name].manager.try_add_wrapper(bufnr)
end

---Setup a language server by providing a name
---@param server_name string name of the language server
---@param user_config table [optional] when available it will take predence over any default configurations
function M.setup(server_name)
	vim.validate { name = { server_name, "string" } }

	if is_client_active(server_name) then
		return
	end

	local conf = resolve_config()

	local servers = require "nvim-lsp-installer.servers"
	local server_available, requested_server = servers.get_server(server_name)

	local is_overridden = vim.tbl_contains(config.override, server_name)

	if not server_available or is_overridden then
		pcall(function()
			require("lspconfig")[server_name].setup(conf)
			buf_try_add(server_name)
		end)
		return
	end

	local install_notification = false

	if not requested_server:is_installed() then
		print("is not isntalled")
		if config.automatic_servers_installation then
			print "Automatic server installation detected"
			requested_server:install()
			install_notification = true
		else
			print(requested_server.name .. " is not managed by the automatic installer")
		end
	end

	requested_server:on_ready(function()
		if install_notification then
			vim.notify(string.format("Installation complete for [%s] server", requested_server.name), vim.log.levels.INFO)
		end
		install_notification = false
		requested_server:setup(conf)
	end)
end

return M
