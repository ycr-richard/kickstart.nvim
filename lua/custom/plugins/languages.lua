-- Personal language settings, layered on top of Kickstart's plugin specs.
---@module 'lazy'
---@type LazySpec
return {
  {
    'mason-org/mason-lspconfig.nvim',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      for _, server in ipairs { 'clangd', 'pyright' } do
        if not vim.tbl_contains(opts.ensure_installed, server) then table.insert(opts.ensure_installed, server) end
      end
    end,
  },
  {
    'neovim/nvim-lspconfig',
    opts = function(plugin)
      -- Preserve Kickstart's setup, including its Lua server and LSP keymaps.
      local kickstart_config = plugin.config
      plugin.config = function(...)
        kickstart_config(...)
        for _, server in ipairs { 'clangd', 'pyright' } do
          vim.lsp.config(server, {})
          vim.lsp.enable(server)
        end
      end
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        python = { 'isort', 'black' },
      },
    },
  },
}
