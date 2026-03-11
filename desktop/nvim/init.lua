vim.cmd("source ~/.vimrc")

-- nvim's built-in ftplugins call vim.treesitter.start() before lazy.nvim has
-- finished loading nvim-treesitter and adding its parser directory to rtp.
-- Wrap it to fail silently; once parsers are compiled subsequent calls succeed.
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(...)
  pcall(_ts_start, ...)
end

-- Bootstrap lazy.nvim (mirrors server config)
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "plugins" },          -- base server plugins (nvim/lua/plugins/)
    { import = "desktop_plugins" },  -- desktop extras (desktop/nvim/lua/plugins/)
  },
  install = { colorscheme = { "monokai" } },
  checker = { enabled = true },
})
