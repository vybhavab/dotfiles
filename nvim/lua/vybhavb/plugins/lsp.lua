local lspconfig = require 'lspconfig'
local configs = require("lspconfig/configs")

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

    if client.resolved_capabilities.document_formatting then
       print(string.format("Formatting supported %s", client.name))
       vim.cmd("autocmd BufWritePost <buffer> lua vim.lsp.buf.formatting()")
    end
end

local function init()
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
      properties = {
        'documentation',
        'detail',
        'additionalTextEdits',
      }
    }

    local languageServers = {"clangd", "texlab", "graphql"}

    for _, lsp in ipairs(languageServers) do
        if lspconfig[lsp] then
            lspconfig[lsp].setup({ capabilities = capabilities, on_attach = on_attach })
        end
    end

    local null_ls = require("null-ls")

    local sources = {null_ls.builtins.formatting.eslint_d}
    null_ls.config {sources=sources}
    require("lspconfig")["null-ls"].setup {
      on_attach = on_attach
    }

    local ts_utils = require 'vybhavb.plugins.lsp-ts-utils'

    lspconfig.tsserver.setup({
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.resolved_capabilities.document_formatting = false
          ts_utils(client)
          on_attach(client, bufnr)
        end,
        settings = {documentFormatting = false}
    })

    -- Formatting via efm
    -- local prettier = require "vybhavb.efm.prettier"
    local eslint = require "vybhavb.efm.eslint"

    local languages = {
      typescript = {eslint},
      javascript = {eslint},
      typescriptreact = {eslint},
      javascriptreact = {eslint},
      json = {prettier},
      html = {prettier},
      scss = {prettier},
      css = {prettier},
      markdown = {prettier},
    }

    lspconfig.efm.setup {
      root_dir = lspconfig.util.root_pattern("yarn.lock", "lerna.json", ".git"),
      filetypes = vim.tbl_keys(languages),
      init_options = {documentFormatting = false, codeAction = true},
      settings = {languages = languages, log_level = 1, log_file = '~/efm.log'},
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

