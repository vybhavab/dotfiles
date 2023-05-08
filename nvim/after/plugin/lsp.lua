local lsp_formatting_augroup = vim.api.nvim_create_augroup('LspFormatting', {})
local lsp = require("lsp-zero")

lsp.preset({
  name="recommended",
  manage_nvim_cmp = true,
  suggest_lsp_servers = false,
  sign_icons = {
    error = 'E',
    warn = 'W',
    hint = 'H',
    info = 'I'
  }
})

-- Fix Undefined global 'vim'
lsp.extend_cmp()
local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}


cmp.setup({
  sources = {
    {name = "copilot", group_index = 2},
    {name = 'nvim_lsp'},
    {name = 'path', group_index = 2},
    {name = 'luasnip' , group_index = 2}, -- For luasnip users.
    {name = 'buffer'},
  },
  mapping = {
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<CR>'] = cmp.mapping.confirm({ behavior= cmp.ConfirmBehavior.Replace, select = false }),
    ['<C-y>'] = cmp.mapping.confirm({ behavior= cmp.ConfirmBehavior.Replace, select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }
})

local function lsp_format_onsave(bufnr)
  vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_formatting_augroup,
    -- buffer = bufnr, -- cannot use both pattern and bufnr
    pattern = "*.tsx,*.ts,*.jsx,*.js",
    callback = function()
      vim.cmd[[EslintFixAll]]
      filter = function(c)
        return c.name == "eslint"
      end
    end,
  })
end

lsp.on_attach(function(client, bufnr)
    local opts = {buffer = bufnr, remap = false}

    lsp_format_onsave(bufnr)

    vim.keymap.set("n", "vd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'vD', function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vh", function() vim.diagnostic.open_float() end, opts)

    vim.keymap.set('n','<leader>vld', function() vim.diagnostic.show_line_diagnostics() end, opts)

    vim.keymap.set("n", "vn", function() vim.diagnostic.goto_next() end, opts)
    vim.keymap.set("n", "vN", function() vim.diagnostic.goto_prev() end, opts)
    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
end)

lsp.ensure_installed({
    'tsserver',
    'rust_analyzer',
    'clangd',
    'eslint',
    'tailwindcss',
})


lsp.setup()

vim.diagnostic.config({
    virtual_text = true
})
