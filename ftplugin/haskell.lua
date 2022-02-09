local hls_flags = {
	"--lsp",
}
local opts = {
	cmd = { "haskell-language-server", unpack(hls_flags) },
	on_attach = custom_on_attach,
}

require("lsp.manager").setup("haskell-language-server", opts)
vim.opt.tabstop                                      = 2 -- insert 2 spaces for a tab
vim.opt.shiftwidth                                   = 2 -- use 2 spaces for << en >>
vim.opt.expandtab                                    = true -- don't use tab character instead of spaces for tabs
