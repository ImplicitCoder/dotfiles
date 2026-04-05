-- LSP setup using the nvim 0.11 native API (vim.lsp.config / vim.lsp.enable).
-- nvim-lspconfig v2 now acts as a config *provider* — it registers default
-- server configs (cmd, filetypes, root_markers) into vim.lsp.config, which
-- we then extend or override before calling vim.lsp.enable().
return {
  -- Mason: binary installer for LSP servers, linters, formatters
  {
    "williamboman/mason.nvim",
    build = ":MasonUpdate",
    opts = {},
  },

  -- Tells Mason which servers to keep installed
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",   -- Lua (editing neovim configs)
        "pyright",  -- Python
        "ts_ls",    -- TypeScript / JavaScript
        "eslint",   -- ESLint diagnostics + fix on save
        "cssls",    -- CSS / SCSS / Less
        "html",     -- HTML
      },
    },
  },

  -- nvim-lspconfig registers default server configs; we override via vim.lsp.config
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Broadcast extended completion capabilities to every server
      vim.lsp.config("*", { capabilities = capabilities })

      -- Suppress the "global vim" undefined-variable warning in Lua files
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = { diagnostics = { globals = { "vim" } } },
        },
      })

      -- Run eslint fix-all automatically on save
      vim.lsp.config("eslint", {
        on_attach = function(_, bufnr)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
          })
        end,
      })

      -- Activate the servers (nvim-lspconfig already registered their defaults)
      vim.lsp.enable({ "lua_ls", "pyright", "ts_ls", "eslint", "cssls", "html" })

      -- Inline diagnostics display
      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      -- Keymaps active only when an LSP server attaches to a buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local opts = { buffer = ev.buf }
          vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts)
          vim.keymap.set("n", "gD",         vim.lsp.buf.declaration,    opts)
          vim.keymap.set("n", "gr",         vim.lsp.buf.references,     opts)
          vim.keymap.set("n", "gi",         vim.lsp.buf.implementation, opts)
          vim.keymap.set("n", "K",          vim.lsp.buf.hover,          opts)
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,         opts)
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,    opts)
          vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev,   opts)
          vim.keymap.set("n", "]d",         vim.diagnostic.goto_next,   opts)
          vim.keymap.set("n", "<leader>d",  function() vim.diagnostic.open_float(nil, { focus = true }) end, opts)
        end,
      })
    end,
  },

  -- Extend nvim-cmp to include LSP completions as the top-priority source
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-nvim-lsp" },
    opts = function(_, opts)
      table.insert(opts.sources, 1, { name = "nvim_lsp" })
      return opts
    end,
  },
}
