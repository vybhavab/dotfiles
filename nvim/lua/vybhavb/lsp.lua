local on_attach = require'completion'.on_attach

require'lspconfig'.tsserver.setup{ on_attach=on_attach }

require'lspconfig'.clangd.setup {
    on_attach = on_attach,
    root_dir = function() return vim.loop.cwd() end
}

require'lspconfig'.pyls.setup{ on_attach=on_attach }
