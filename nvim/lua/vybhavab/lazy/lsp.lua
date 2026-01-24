return {
  'neovim/nvim-lspconfig',
  dependencies = {
    "onsails/lspkind.nvim",
    'saghen/blink.cmp',
    'j-hui/fidget.nvim',
  },
  config = function()
    require("fidget").setup({})

    local lspconfig_configs = require('lspconfig.configs')

    local lsp_servers = {
      --'ts_ls',
      'tsgo',
      'lua_ls',
      'gopls',
      'bashls',
      'rust_analyzer',
      'clangd',
      'html',
      'cssls',
      'tailwindcss',
      'eslint',
      'biome',
      'basedpyright',
      'jsonls'
    }

    for _, server in ipairs(lsp_servers) do
      local config_path = 'vybhavab.lsp.' .. server
      local ok, custom_config = pcall(require, config_path)
      if ok then
        local merged = custom_config

        -- Extend the default config shipped by nvim-lspconfig instead of replacing it.
        local has_builtin = pcall(require, 'lspconfig.configs.' .. server)
        local defaults = has_builtin
            and lspconfig_configs[server]
            and lspconfig_configs[server].document_config
            and lspconfig_configs[server].document_config.default_config

        if defaults then
          merged = vim.tbl_deep_extend('force', vim.deepcopy(defaults), custom_config)
        end

        vim.lsp.config(server, merged)
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
