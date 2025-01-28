require("vybhavab.sets")
require("vybhavab.remap")
require("vybhavab.lazy_init")

local augroup = vim.api.nvim_create_augroup
local VybhavABGroup = augroup('VybhavAB', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd('LspAttach', {
  group = VybhavABGroup,
  callback = function(e)
    local opts = { buffer = e.buf }
    vim.keymap.set("n", "vd", function() vim.lsp.buf.definition() end, opts)
    vim.keymap.set('n', 'vD', function() vim.lsp.buf.declaration() end, opts)
    vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)

    vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
    vim.keymap.set("n", "<leader>vh", function() vim.diagnostic.open_float() end, opts)

    vim.keymap.set('n','<leader>vld', function() vim.diagnostic.show_line_diagnostics() end, opts)

    vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
    vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
    vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
    vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)

    vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)

    augroup("__formatter__", { clear = true })
    autocmd("BufWritePost", {
      group = "__formatter__",
      command = ":FormatWrite",
    })

    autocmd({ "BufWritePost" }, {
      group = VybhavABGroup,
      callback = function()
        require("lint").try_lint()
      end,
    })
  end
})

autocmd({"FileReadPost", "BufReadPost"}, {
  group = VybhavABGroup,
  pattern = '*',
  callback = function()
    vim.api.nvim_command('normal zR')
  end
})

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25
