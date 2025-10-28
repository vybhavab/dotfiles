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

    for _, server in ipairs(lsp_servers) do
      local config_path = 'vybhavab.lsp.' .. server
      local ok, custom_config = pcall(require, config_path)
      if ok then
        vim.lsp.config(server, custom_config)
      end
    end

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
