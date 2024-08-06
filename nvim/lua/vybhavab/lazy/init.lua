return {
  'mbbill/undotree',
  'folke/zen-mode.nvim',
  'kyazdani42/nvim-web-devicons',
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    config = function ()
      require('gitsigns').setup({
        current_line_blame = true
      })
    end
  },
  {
    'mbbill/undotree',
    config = function()
      vim.keymap.set("n", "<F9>", ":UndotreeToggle<CR>")
    end
  },
  {
    'dmmulroy/ts-error-translator.nvim',
    config = function()
      require('ts-error-translator').setup()
    end
  },
  'sbdchd/neoformat',
  'nvim-lua/plenary.nvim',
}
