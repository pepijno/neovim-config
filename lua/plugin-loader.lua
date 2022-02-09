local utils = require "utils"

local M = {}

local compile_path = vim.fn.stdpath "config" .. "/plugin/packer_compiled.lua"

function M:init()
	local install_path = vim.fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
	local package_root = vim.fn.stdpath "data" .. "/site/pack"

	if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
		vim.fn.system { "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path }
		vim.cmd "packadd packer.nvim"
	end

	local log_level = in_headless and "debug" or "warn"

	local _, packer = pcall(require, "packer")
	packer.init {
		package_root = package_root,
		compile_path = compile_path,
		git = { clone_timeout = 300 },
		max_jobs = 50,
		display = {
			open_fn = function()
				return require("packer.util").float { border = "rounded" }
			end,
		},
	}
end

local function pcall_packer_command(cmd, kwargs)
	local status_ok, msg = pcall(function()
		require("packer")[cmd](unpack(kwargs or {}))
	end)
	if not status_ok then
		print(cmd .. " failed with: " .. vim.inspect(msg))
	end
end

function M:cache_clear()
	if vim.fn.delete(compile_path) == 0 then
--		print("deleted packer_compiled.lua")
	end
end

function M:recompile()
	M:cache_clear()
	pcall_packer_command "compile"
	if utils.is_file(compile_path) then
--		print "generated packer_compiled.lua"
	end
end

function M:load(configurations)
--	print "loading plugins configuration"
	local packer_available, packer = pcall(require, "packer")
	if not packer_available then
--		print "skipping loading plugins until Packer is installed"
		return
	end
	local status_ok, _ = xpcall(function()
		packer.startup(function(use)
			for _, plugins in ipairs(configurations) do
				for _, plugin in ipairs(plugins) do
					use(plugin)
				end
			end
		end)
	end, debug.traceback)
	if not status_ok then
		print "problems detected while loading plugins' configurations"
	end
end

return M
