return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  event = "VimEnter",
  keys = {
    { "<leader>e", ":Neotree toggle<CR>", desc = "Toggle Neo-tree" },
  },
  config = function()
    require("neo-tree").setup({
      window = { position = "left", width = 30 },
      filesystem = {
        follow_current_file = { enabled = true },
        hijack_netrw_behavior = "open_current",
        filtered_items = {
          visible = true,       -- show hidden files, dimmed rather than hidden
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
    })

    -- Close neo-tree when quitting the last real window, or when :qa is run
    -- from inside neo-tree (its unlisted buffer is skipped by :qa otherwise,
    -- leaving it as a stray window after all file windows close).
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
        local in_neotree = vim.bo.filetype == "neo-tree"
        if real_wins <= 1 or in_neotree then
          vim.cmd("Neotree close")
        end
      end,
    })

    -- Plugin loaded on VimEnter, so show immediately and move focus to editor
    require("neo-tree.command").execute({ action = "show" })
    vim.cmd("wincmd l")
  end,
}
