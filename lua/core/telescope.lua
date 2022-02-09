local M = {}

M.config = function()
	local status_ok, actions = pcall(require, "telescope.actions")
	if not status_ok then
		return
	end
	local telescope_conf = {
		active = true,
		defaults = {
			layout_config = {
				prompt_position = "bottom",
			},
			vimgrep_arguments = {
				"rg",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--smart-case",
				"--hidden",
				"--fixed-strings",
			},
			prompt_prefix = "❯ ",
			selection_caret = "❯ ",
			color_devicons = true,
			selection_strategy = "reset",
			layout_strategy = "flex",
			mappings = {
				-- i = {
				-- 	["<C-i>"] = actions.create_md_link
				-- },
				n = {
					["<C-c>"] = actions.close,
					-- ["<C-i>"] = actions.create_md_link
				}
			},
			set_env = { ['COLORTERM'] = 'truecolor' }, -- default = nil,
		}
	}
	require("telescope").setup(telescope_conf)
end

return M
