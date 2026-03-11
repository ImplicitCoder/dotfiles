-- Fuzzy finder for files, grep results, LSP symbols, git history, etc.
-- telescope-fzf-native compiles a C extension for faster sorting.
return {
  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    config = function()
      local telescope = require("telescope")
      local builtin = require("telescope.builtin")

      telescope.setup({
        defaults = {
          -- Start in insert mode so you can type immediately
          initial_mode = "insert",
          -- Show hidden files (respects .gitignore unless ignored_by_git = false)
          file_ignore_patterns = { "node_modules", ".git/" },
        },
        pickers = {
          find_files = { hidden = true },
        },
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          },
        },
      })

      telescope.load_extension("fzf")

      -- Global keymaps
      vim.keymap.set("n", "<leader>ff", builtin.find_files,              { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", builtin.live_grep,               { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", builtin.buffers,                 { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", builtin.help_tags,               { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fr", builtin.oldfiles,                { desc = "Recent files" })
      vim.keymap.set("n", "<leader>fs", builtin.lsp_document_symbols,    { desc = "Document symbols" })
      vim.keymap.set("n", "<leader>fd", builtin.diagnostics,             { desc = "Diagnostics" })
      vim.keymap.set("n", "<leader>gc", builtin.git_commits,             { desc = "Git commits" })
      vim.keymap.set("n", "<leader>gs", builtin.git_status,              { desc = "Git status" })
    end,
  },
}
