-- Formatter runner. Runs formatters on save; Mason installs the binaries.
-- mason-conform is handled by manually listing tools in ensure_installed below.
return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json       = { "prettier" },
        yaml       = { "prettier" },
        html       = { "prettier" },
        css        = { "prettier" },
        scss       = { "prettier" },
        markdown   = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        timeout_ms = 1000,
      },
    },
  },

  -- Ensure formatter binaries are installed via Mason
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "stylua",    -- Lua formatter
        "black",     -- Python formatter
        "prettier",  -- JS/TS/JSON/CSS/HTML/Markdown formatter
      },
    },
  },
}
