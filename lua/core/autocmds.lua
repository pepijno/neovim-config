local M = {}

M.autocommands = {
	general = {
--		{
--			"Filetype",
--			"*",
--			"lua require('lsp.utils').do_filetype(vim.fn.expand(\"<amatch>\"))",
--		},
		{
			"TextYankPost",
			"*",
			"lua vim.highlight.on_yank{higroup=\"IncSearch\", timeout=3000}",
		},
		{
			"BufWinEnter",
			"*",
			"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
		},
		{
			"BufRead",
			"*",
			"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
		},
		{
			"BufNewFile",
			"*",
			"setlocal formatoptions-=c formatoptions-=r formatoptions-=o",
		},
	},
}

function M.define_augroups(definitions)
	for group_name, definition in pairs(definitions) do
		vim.cmd("augroup " .. group_name)
		vim.cmd "autocmd!"

		for _, def in pairs(definition) do
			local command = table.concat(vim.tbl_flatten { "autocmd", def }, " ")
			vim.cmd(command)
		end

		vim.cmd "augroup END"
	end
end

return M
