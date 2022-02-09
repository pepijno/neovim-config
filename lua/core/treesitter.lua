local M = {}

function M:config()
	local configuration = {
		ensure_installed = { "haskell", "nix", "lua", "c", "cpp", "bash", "fish", "java", "kotlin", "zig", "query" },
		-- ensure_installed = "maintained",
		highlight = {
			enable = true,
			additional_vim_regex_highlighting = true
		},
		indent = {
			enable = true,
		},
		autotag = { enable = false },
		rainbow = {
			enable = true,
			extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
			max_file_lines = 1000, -- Do not enable for files with more than 1000 lines, int
		},
		context_commentstring = {
			enable = true,
			config = {
				-- Languages that have a single comment style
				typescript = "// %s",
				css = "/* %s */",
				scss = "/* %s */",
				html = "<!-- %s -->",
				svelte = "<!-- %s -->",
				vue = "<!-- %s -->",
				json = "",
			},
		},
		playground = {
			enable = true,
			disable = {},
			updatetime = 25, -- Debounced time for highlighting nodes in the playground from source code
			persist_queries = false, -- Whether the query persists across vim sessions
			keybindings = {
				toggle_query_editor = "o",
				toggle_hl_groups = "i",
				toggle_injected_languages = "t",
				toggle_anonymous_nodes = "a",
				toggle_language_display = "I",
				focus_language = "f",
				unfocus_language = "F",
				update = "R",
				goto_node = "<cr>",
				show_help = "?",
			},
		},
	}

	local status_ok, treesitter_configs = pcall(require, "nvim-treesitter.configs")
	if not status_ok then
		Log:get_default().error "Failed to load nvim-treesitter.configs"
		return
	end

	local opts = vim.deepcopy(configuration)

	-- avoid running any installers in headless mode since it's harder to detect failures
	opts.ensure_installed = #vim.api.nvim_list_uis() == 0 and {} or opts.ensure_installed
	treesitter_configs.setup(opts)
end

return M
