local lspconfig = require 'lspconfig'

local format_async = function(err, _, result, _, bufnr)
    if err ~= nil or result == nil then return end
    if not vim.api.nvim_buf_get_option(bufnr, "modified") then
        local view = vim.fn.winsaveview()
        vim.lsp.util.apply_text_edits(result, bufnr)
        vim.fn.winrestview(view)
        if bufnr == vim.api.nvim_get_current_buf() then
            vim.api.nvim_command("noautocmd :update")
        end
    end
end

vim.lsp.handlers["textDocument/formatting"] = format_async

_G.lsp_organize_imports = function()
    local params = {
        command = "_typescript.organizeImports",
        arguments = {vim.api.nvim_buf_get_name(0)},
        title = ""
    }
    vim.lsp.buf.execute_command(params)
end

local on_attach = function (client, bufnr)
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
    buf_set_keymap('n','<leader>vld','<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',opts)
    buf_set_keymap('n','<leader>vn','<Cmd>lua vim.lsp.diagnostic.goto_next()<CR>',opts)
    buf_set_keymap('n','<leader>vN','<Cmd>lua vim.lsp.diagnostic.goto_prev()<CR>',opts)

    -- Set some keybinds conditional on server capabilities
    if client.resolved_capabilities.document_formatting then
         buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
    end

    if client.resolved_capabilities.document_range_formatting then
         buf_set_keymap("v", "<space>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
    end
    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
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

--    if client.resolved_capabilities.document_formatting then
--       print(string.format("Formatting supported %s", client.name))
--       vim.api.nvim_exec([[
--        augroup LspAutocommands
--            autocmd! * <buffer>
--            autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting() 
--        augroup END
--        ]], true)
--    end
end

local function init()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    local tssCapabilities = capabilities
    tssCapabilities.textDocument.document_formatting = false

    local languageServers = {"clangd", "pyls", "texlab", "graphql"}

    for _, lsp in ipairs(languageServers) do
            lspconfig[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
    end

    lspconfig["tsserver"].setup({
        capabilities = tssCapabilities,
        on_attach = on_attach
    })

    local filetypes = {
        typescript = "eslint",
        typescriptreact = "eslint",
    }

    local linters = {
        eslint = {
            sourceName = "eslint",
            command = "eslint_d",
            rootPatterns = {".eslintrc.js", "package.json"},
            debounce = 100,
            args = {"--stdin", "--stdin-filename", "%filepath", "--format", "json"},
            parseJson = {
                errorsRoot = "[0].messages",
                line = "line",
                column = "column",
                endLine = "endLine",
                endColumn = "endColumn",
                message = "${message} [${ruleId}]",
                security = "severity"
            },
            securities = {[2] = "error", [1] = "warning"}
        }
    }
    local formatters = {
        prettier = {command = "prettier", args = {"--stdin-filepath", "%filepath"}}
    }
    local formatFiletypes = {
        typescript = "prettier",
        typescriptreact = "prettier"
    }

    lspconfig.diagnosticls.setup {
        on_attach = on_attach,
        filetypes = vim.tbl_keys(filetypes),
        init_options = {
            filetypes = filetypes,
            linters = linters,
            formatters = formatters,
            formatFiletypes = formatFiletypes
        }
    }

    local opts = {
        highlight_hovered_item = false,
        show_guides = true,
    }

    require('symbols-outline').setup(opts)
end

return {
    init = init
}

