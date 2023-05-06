local function init()
    local map = vim.api.nvim_set_keymap
    local options = { noremap = true }
    map('n', '<leader>gg', ':LazyGit<CR>', options)

end

return {
    init = init
}
