local M = {}

local config = require("lsp/config")

local function is_directory(path)
  local stat = vim.loop.fs_stat(path)
  return stat and stat.type == "directory" or false
end

local function lsp_highlight_document(client)
	if client.resolved_capabilities.document_highlight then
		vim.api.nvim_exec(
			[[
			augroup lsp_document_highlight
			autocmd! * <buffer>
			autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
			autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
			augroup END
			]],
			false
		)
	end
end

local function lsp_code_lens_refresh(client)
	if client.resolved_capabilities.code_lens then
		vim.api.nvim_exec(
			[[
			augroup lsp_code_lens_refresh
			autocmd! * <buffer>
			autocmd InsertLeave <buffer> lua vim.lsp.codelens.refresh()
			autocmd InsertLeave <buffer> lua vim.lsp.codelens.display()
			augroup END
			]],
			false
		)
	end
end

local function add_lsp_buffer_keybindings(bufnr)
	local mappings = {
		normal_mode = "n",
		insert_mode = "i",
		visual_mode = "v",
	}

	-- if lvim.builtin.which_key.active then
	--   -- Remap using which_key
	--   local status_ok, wk = pcall(require, "which-key")
	--   if not status_ok then
	--     return
	--   end
	--   for mode_name, mode_char in pairs(mappings) do
	--     wk.register(lvim.lsp.buffer_mappings[mode_name], { mode = mode_char, buffer = bufnr })
	--   end
	-- else
	-- Remap using nvim api
	for mode_name, mode_char in pairs(mappings) do
		for key, remap in pairs(config.buffer_mappings[mode_name]) do
			vim.api.nvim_buf_set_keymap(bufnr, mode_char, key, remap[1], { noremap = true, silent = true })
		end
	end
	-- end
end

function M.common_capabilities()
	local capabilities = vim.lsp.protocol.make_client_capabilities()
	capabilities.textDocument.completion.completionItem.snippetSupport = true
	capabilities.textDocument.completion.completionItem.resolveSupport = {
		properties = {
			"documentation",
			"detail",
			"additionalTextEdits",
		},
	}

	local status_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
	if status_ok then
		capabilities = cmp_nvim_lsp.update_capabilities(capabilities)
	end

	return capabilities
end

local function select_default_formatter(client)
	if client.name == "null-ls" or not client.resolved_capabilities.document_formatting then
		return
	end
end

function M.common_on_init(client, bufnr)
	select_default_formatter(client)
end

function M.common_on_attach(client, bufnr)
	lsp_highlight_document(client)
	lsp_code_lens_refresh(client)
	add_lsp_buffer_keybindings(bufnr)
end

local function bootstrap_nlsp(opts)
	opts = opts or {}
	local lsp_settings_status_ok, lsp_settings = pcall(require, "nlspsettings")
	if lsp_settings_status_ok then
		lsp_settings.setup(opts)
	end
end

function M.get_common_opts()
	return {
		on_attach = M.common_on_attach,
		on_init = M.common_on_init,
		capabilities = M.common_capabilities(),
	}
end

local LSP_DEPRECATED_SIGN_MAP = {
	["LspDiagnosticsSignError"] = "DiagnosticSignError",
	["LspDiagnosticsSignWarning"] = "DiagnosticSignWarn",
	["LspDiagnosticsSignHint"] = "DiagnosticSignHint",
	["LspDiagnosticsSignInformation"] = "DiagnosticSignInfo",
}

function M:setup()
	local lsp_status_ok, _ = pcall(require, "lspconfig")
	if not lsp_status_ok then
		return
	end

	local diagnostics = config.diagnostics

	for _, sign in ipairs(diagnostics.signs.values) do
		local lsp_sign_name = LSP_DEPRECATED_SIGN_MAP[sign.name]
		if lsp_sign_name then
			vim.fn.sign_define(lsp_sign_name, { texthl = lsp_sign_name, text = sign.text, numhl = lsp_sign_name })
		end
		vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
	end

	require("lsp.handlers").setup()

	if not is_directory(config.templates_dir) then
		require("lsp.templates").generate_templates()
	end

	bootstrap_nlsp { config_home =  vim.fn.stdpath("config") .. "/lsp-settings" }

	require("lsp.null-ls").setup()

	-- require("lvim.core.autocmds").configure_format_on_save()

	-- local formatters = require "lsp.null-ls.formatters"
	-- formatters.setup { { exe = "LuaFormatter", args = {} } }

	-- local clangd_flags = {
	-- 	"--all-scopes-completion",
	-- 	"--suggest-missing-includes",
	-- 	"--background-index",
	-- 	"--header-insertion=never",
	-- 	"--cross-file-rename",
	-- 	"--clang-tidy",
	-- 	"--clang-tidy-checks=-*,llvm-*,clang-analyzer-*",
	-- }
	-- local opts = {
	-- 	cmd = { "clangd", unpack(clangd_flags) },
	-- 	on_attach = custom_on_attach,
	-- }

	-- require("lsp.manager").setup("clangd", opts)
end

return M
