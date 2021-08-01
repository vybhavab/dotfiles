local function init()
    require("harpoon").setup({});

    local map = vim.api.nvim_set_keymap
    local options = {noremap = true }

    map('n','<leader>a', ':lua require("harpoon.mark").add_file()<CR>',options)
    map('n', '<C-e>',':lua require("harpoon.ui").toggle_quick_menu()<CR>', options)
    map('n','<C-a>', ':lua require("harpoon.ui").nav_file(1)<CR>',options)
    map('n','<C-s>', ':lua require("harpoon.ui").nav_file(2)<CR>',options)
    map('n','<C-d>', ':lua require("harpoon.ui").nav_file(3)<CR>',options)
    map('n','<C-f>', ':lua require("harpoon.ui").nav_file(4)<CR>',options)
    map('n','<C-y>', ':lua require("harpoon.mark").rm_file()<CR>',options)
    map('n','<leader><C-s>', ':lua require("harpoon.mark").shorten_list()<CR>',options)
    map('n','<leader><C-d>', ':lua require("harpoon.mark").clear_all()<CR>',options)
    map('n','<leader>r', ':lua require("harpoon.mark").promote()<CR>',options)
    map('n','<leader>ts', ':lua require("harpoon.term").gotoTerminal(1)<CR>',options)
    map('n','<leader>td', ':lua require("harpoon.term").gotoTerminal(2)<CR>',options)
    map('n','<leader>cs', ':lua require("harpoon.term").sendCommand(1, 1)<CR>',options)
    map('n','<leader>cd', ':lua require("harpoon.term").sendCommand(2, 2)<CR>',options)
end


return {
    init = init
}
