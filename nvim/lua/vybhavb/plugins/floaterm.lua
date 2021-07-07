local function init()
    local map = vim.api.nvim_set_keymap
    local options = { noremap = true }

    map('n', '<leader>gg', '<CMD>FloatermToggle! --height=0.9 --width=0.9 --wintype=floating lazygit<CR>', options)

end

return {
    init = init
}
