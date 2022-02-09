local M = {}

local config = require "lsp.config"

function M:setup()
  local status_ok, null_ls = pcall(require, "null-ls")
  if not status_ok then
    print "Missing null-ls dependency"
    return
  end

  null_ls.config(config.null_ls.config)
  local default_opts = require("lsp").get_common_opts()

  if vim.tbl_isempty(config.null_ls.setup or {}) then
    config.null_ls.setup = default_opts
  end

  require("lspconfig")["null-ls"].setup(config.null_ls.setup)
end

return M
