" Source shared config from ~/.vimrc
source ~/.vimrc

" ============================================
"  Plugin Manager (lazy.nvim) + Plugins
" ============================================
lua << EOF
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    "crusoexia/vim-monokai",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd("colorscheme monokai")
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = { position = "left", width = 30 },
        filesystem = {
          follow_current_file = { enabled = true },
          hijack_netrw_behavior = "open_current",
        },
      })

      -- Close neo-tree when quitting the last real window
      vim.api.nvim_create_autocmd("QuitPre", {
        callback = function()
          local wins = vim.api.nvim_list_wins()
          local real_wins = 0
          for _, w in ipairs(wins) do
            local cfg = vim.api.nvim_win_get_config(w)
            local ft = vim.bo[vim.api.nvim_win_get_buf(w)].filetype
            if cfg.relative == "" and ft ~= "neo-tree" then
              real_wins = real_wins + 1
            end
          end
          if real_wins == 1 then
            vim.cmd("Neotree close")
          end
        end,
      })

      -- Open neo-tree automatically on startup, then return focus to editor
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function()
          require("neo-tree.command").execute({ action = "show" })
          vim.cmd("wincmd l")
        end,
      })
    end,
  },
})
EOF

" Toggle neo-tree with <leader>e
nnoremap <leader>e :Neotree toggle<CR>

