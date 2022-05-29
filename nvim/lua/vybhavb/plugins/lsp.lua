local lspconfig = require 'lspconfig'

_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

local on_attach = function (client, bufnr)
    require "lsp_signature".on_attach()

    print("'" .. client.name .. "' language server started" );

    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = {noremap=true, silent=true}
    buf_set_keymap('n', 'vD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'vd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'vi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'vsh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n','<leader>vrr', '<Cmd>lua vim.lsp.buf.references()<CR>',opts)
    buf_set_keymap('n','<leader>vrn', '<Cmd>lua vim.lsp.buf.rename()<CR>',opts)
    buf_set_keymap('n','<leader>vh', '<Cmd>lua vim.lsp.buf.hover()<CR>',opts)
    buf_set_keymap('n','<leader>vca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',opts)
    buf_set_keymap('n','<leader>vld','<Cmd>lua vim.diagnostic.show_line_diagnostics()<CR>',opts)
    buf_set_keymap('n','<leader>vn','<Cmd>lua vim.diagnostic.goto_next()<CR>',opts)
    buf_set_keymap('n','<leader>vN','<Cmd>lua vim.diagnostic.goto_prev()<CR>',opts)

    -- Set some keybinds conditional on server capabilities
    if client.server_capabilities.document_formatting then
         buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    if client.server_capabilities.document_range_formatting then
         buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.document_highlight then
       vim.api.nvim_exec([[
         hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
         hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
         hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
         augroup lsp_document_highlight
           autocmd! * <buffer>
           autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
           autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
         augroup END
       ]], false)
    end
end

local function lspInstall(capabilities)
    local lsp_installer = require("nvim-lsp-installer")
    lsp_installer.on_server_ready(function(server)
      local opts = {}
      opts.capabilities = capabilities
      opts.on_attach = on_attach

      server:setup(opts)
    end)

end

local function init()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    lspconfig.clangd.setup({ capabilities = capabilities, on_attach = on_attach })

    lspconfig.eslint.setup({
      capabilities = capabilities,
      on_attach = function(client, bufnr)
        client.server_capabilities.document_formatting = true
        vim.api.nvim_exec([[
          augroup eslint_fix_all_lsp
            autocmd!
            autocmd BufWritePre *.tsx,*.ts,*.jsx,*.js EslintFixAll
          augroup END
        ]], false)
        on_attach(client, bufnr)
      end,
    })

    lspconfig.texlab.setup({ capabilities = capabilities, on_attach = on_attach })

    lspconfig.pyright.setup({ capabilities = capabilities, on_attach = on_attach })


    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.document_formatting = false
          on_attach(client, bufnr)
        end,
        root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", ".git") or vim.loop.cwd()
    })

    lspconfig.tailwindcss.setup({
      capabilities = capabilities,
      on_attach = on_attach
    })

    lspInstall(capabilities)

    local opts = {
        highlight_hovered_item = true,
        show_guides = true
    }

    require('symbols-outline').setup(opts)
end

return {
    init = init
}

