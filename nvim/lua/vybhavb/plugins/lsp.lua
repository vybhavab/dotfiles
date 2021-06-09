local lspconfig = require 'lspconfig'

local on_attach = function (client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

    local opts = {noremap=true, silent=true}
    buf_set_keymap('n', 'vD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'vd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'vi', '<Cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', 'vsh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', 'vsh', '<Cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n','<leader>vrr', '<Cmd>lua vim.lsp.buf.references()<CR>',opts)
    buf_set_keymap('n','<leader>vrn', '<Cmd>lua vim.lsp.buf.rename()<CR>',opts)
    buf_set_keymap('n','<leader>vh', '<Cmd>lua vim.lsp.buf.hover()<CR>',opts)
    buf_set_keymap('n','<leader>vca', '<Cmd>lua vim.lsp.buf.code_action()<CR>',opts)
    buf_set_keymap('n','<leader>vsd','<Cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>',opts)
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

    local tssCapabilities = vim.lsp.protocol.make_client_capabilities()
    tssCapabilities.textDocument.completion.completionItem.snippetSupport = true
    tssCapabilities.textDocument.document_formatting = false
    tssCapabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    local languageServers = {"tsserver", "clangd", "pyls", "texlab"}

    for _, lsp in ipairs(languageServers) do
        if lsp == "tsserver" then
            lspconfig[lsp].setup{ capabilities = tssCapabilities , on_attach = on_attach }
        else
            lspconfig[lsp].setup{ capabilities = capabilities, on_attach = on_attach }
        end
    end

    lspconfig.diagnosticls.setup{
        filetypes = {"javascript", "typescript"},
        root_dir = function(fname)
            return lspconfig.util.root_pattern("tsconfig.json")(fname) or lspconfig.util.root_pattern(".eslintrc.js")(fname) or lspconfig.util.root_pattern(".eslintrc.json")(fname);
        end,
        init_options = {
            linters = {
                eslint = {
                    command = "./node_modules/.bin/eslint",
                    rootPatterns = {".eslintrc.js", ".git"},
                    debounce = 100,
                    args = {
                        "--stdin",
                        "--stdin-filename",
                        "%filepath",
                        "--format",
                        "json"
                    },
                    sourceName = "eslint",
                    parseJson = {
                        errorsRoot = "[0].messages",
                        line = "line",
                        column = "column",
                        endLine = "endLine",
                        endColumn = "endColumn",
                        message = "[eslint] ${message} [${ruleId}]",
                        security = "severity"
                    },
                    securities = {
                        [2] = "error",
                        [1] = "warning"
                    }
                },
            },
            filetypes = {
                javascript = "eslint",
                typescript = "eslint",
            }
        },
		on_attach = on_attach
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

