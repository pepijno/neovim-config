local M = {}

local config = require "lsp.config"
local ftplugin_dir = config.templates_dir

local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

function write_file(path, txt, flag)
	vim.loop.fs_open(path, flag, 438, function(open_err, fd)
		assert(not open_err, open_err)
		vim.loop.fs_write(fd, txt, -1, function(write_err)
			assert(not write_err, write_err)
			vim.loop.fs_close(fd, function(close_err)
				assert(not close_err, close_err)
			end)
		end)
	end)
end

function M.remove_template_files()
	-- remove any outdated files
	for _, file in ipairs(vim.fn.glob(ftplugin_dir .. "/*.lua", 1, 1)) do
		vim.fn.delete(file)
	end
end

local function get_supported_filetypes(server_name)
	-- temporary workaround: https://github.com/neovim/nvim-lspconfig/pull/1358
	if server_name == "dockerls" then
		return { "dockerfile" }
	end
	local lsp_installer_servers = require "nvim-lsp-installer.servers"
	local server_available, requested_server = lsp_installer_servers.get_server(server_name)
	if not server_available then
		return {}
	end

	return requested_server:get_supported_filetypes()
end

---Generates an ftplugin file based on the server_name in the selected directory
---@param server_name string name of a valid language server, e.g. pyright, gopls, tsserver, etc.
---@param dir string the full path to the desired directory
function M.generate_ftplugin(server_name, dir)
	local has_custom_provider, _ = pcall(require, "nvim/lsp/providers/" .. server_name)
	if vim.tbl_contains(config.override, server_name) and not has_custom_provider then
		return
	end

	-- we need to go through lspconfig to get the corresponding filetypes currently
	local filetypes = get_supported_filetypes(server_name) or {}
	if not filetypes then
		return
	end

	for _, filetype in ipairs(filetypes) do
		local filename = dir .. "/" .. filetype .. ".lua"
		local setup_cmd = string.format([[require("lsp.manager").setup(%q)]], server_name)
		-- print("using setup_cmd: " .. setup_cmd)
		-- overwrite the file completely
		write_file(filename, setup_cmd .. "\n", "a")
	end
end

---Generates ftplugin files based on a list of server_names
---The files are generated to a runtimepath: "$LUNARVIM_RUNTIME_DIR/site/after/ftplugin/template.lua"
---@param servers_names table list of servers to be enabled. Will add all by default
function M.generate_templates(servers_names)
	servers_names = servers_names or {}

	M.remove_template_files()

	if vim.tbl_isempty(servers_names) then
		local available_servers = require("nvim-lsp-installer.servers").get_available_servers()
		for _, server in pairs(available_servers) do
			table.insert(servers_names, server.name)
		end
	end

	-- create the directory if it didn't exist
	if not is_directory(config.templates_dir) then
		vim.fn.mkdir(ftplugin_dir, "p")
	end

	for _, server in ipairs(servers_names) do
		M.generate_ftplugin(server, ftplugin_dir)
	end
end

return M
