local function init()
    local map = vim.api.nvim_set_keymap
    local options = { noremap = true }

    map('n', '<F5>', ':UndotreeToggle<CR>', options)

end

return {
    init = init
}
