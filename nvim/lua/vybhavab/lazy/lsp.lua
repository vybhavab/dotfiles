return {
  'neovim/nvim-lspconfig',
  dependencies = {
    "onsails/lspkind.nvim",
    'saghen/blink.cmp',
    'rcarriga/nvim-dap-ui',
    'mfussenegger/nvim-dap',
    'j-hui/fidget.nvim',
  },
  config = function ()
    require("fidget").setup({})

    local lsp_servers = { 'tsgo', 'lua_ls', 'gopls', 'bashls', 'rust_analyzer', 'clangd', 'html', 'cssls', 'tailwindcss', 'biome' }

    vim.lsp.enable(lsp_servers)

    vim.diagnostic.config({
      update_in_insert = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      }
    })
  end
}
