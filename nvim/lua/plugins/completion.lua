return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",
  dependencies = {
    "hrsh7th/cmp-buffer",        -- completions from current buffer
    "hrsh7th/cmp-path",          -- file path completions
    "L3MON4D3/LuaSnip",          -- snippet engine (required by nvim-cmp)
    "saadparwaiz1/cmp_luasnip",  -- luasnip source for nvim-cmp
  },
  -- Using opts (function form) instead of config so desktop plugins can
  -- extend the sources table (e.g. inject nvim_lsp) via their own opts spec.
  opts = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")

    return {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<Tab>"]   = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),
        ["<CR>"]      = cmp.mapping.confirm({ select = false }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"]     = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
        { name = "luasnip" },
        { name = "buffer" },
        { name = "path" },
      }),
    }
  end,
}
