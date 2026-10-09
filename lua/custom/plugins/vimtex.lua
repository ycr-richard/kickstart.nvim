return {
  {
    'lervag/vimtex',
    lazy = false,

    init = function()
      vim.g.vimtex_view_method = 'zathura'
      vim.g.vimtex_compiler_method = 'latexmk'

      -- 不要因為 warning 自動跳 quickfix
      vim.g.vimtex_quickfix_mode = 0
    end,
  },
}
