vim.cmd("source ~/.vimrc")

-- nvim's built-in ftplugins (lua, python, etc.) call vim.treesitter.start()
-- unconditionally. On servers where no parsers are compiled this raises a
-- hard error. Wrap it to fail silently instead.
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(...)
  pcall(_ts_start, ...)
end

require("config.lazy")
