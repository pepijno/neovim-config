local utils = {}

function utils.is_file(path)
	local stat = vim.loop.fs_stat(path)
	return stat and stat.type == "file" or false
end

function utils.get_cache_path()
	 return vim.fn.stdpath "cache"
end

return utils
