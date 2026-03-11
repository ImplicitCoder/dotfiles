-- Shows git diff markers in the sign column and provides hunk actions.
return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add          = { text = "▎" },
      change       = { text = "▎" },
      delete       = { text = "" },
      topdelete    = { text = "" },
      changedelete = { text = "▎" },
      untracked    = { text = "▎" },
    },
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      local opts = { buffer = bufnr }

      -- Navigate hunks
      vim.keymap.set("n", "]h", gs.next_hunk,                             opts)
      vim.keymap.set("n", "[h", gs.prev_hunk,                             opts)
      -- Stage / reset individual hunks
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk,                   opts)
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk,                   opts)
      vim.keymap.set("v", "<leader>hs", function() gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
      vim.keymap.set("v", "<leader>hr", function() gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") }) end, opts)
      -- Whole-buffer actions
      vim.keymap.set("n", "<leader>hS", gs.stage_buffer,                 opts)
      vim.keymap.set("n", "<leader>hR", gs.reset_buffer,                 opts)
      vim.keymap.set("n", "<leader>hu", gs.undo_stage_hunk,              opts)
      -- Preview and blame
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk,                 opts)
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, opts)
      vim.keymap.set("n", "<leader>hd", gs.diffthis,                     opts)
    end,
  },
}
