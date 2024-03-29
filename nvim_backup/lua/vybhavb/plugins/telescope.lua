local function init()
    local actions = require('telescope.actions')
    require('telescope').setup {
        defaults = {
            file_sorter = require('telescope.sorters').get_fzy_sorter,
            prompt_prefix = ' >',
            color_devicons = true,

            file_previewer   = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer   = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,

            mappings = {
                i = {
                    ["<C-q>"] = actions.send_to_qflist,
                    ["<esc>"] = actions.close,
                },
            },
            file_ignore_patterns = {
                "*.pyc",
                "*_build/*",
                "**/coverage/*",
                "**/node_modules/*",
                "**/android/*",
                "**/ios/*",
                "**/.git/*"
            }
        },
        pickers = {
          lsp_code_actions = {
            theme="cursor"
          }
        },
        extensions = {
            fzy_native = {
                override_generic_sorter = false,
                override_file_sorter = true,
            }
        }
    }

    require('telescope').load_extension('fzy_native')
    require("telescope").load_extension("git_worktree")

    local map = vim.api.nvim_set_keymap
    local opts = { noremap = true }
    map('n','<leader>ps','<CMD>lua require("telescope.builtin").grep_string({ search = vim.fn.input("Grep > ")})<CR>',opts)
    map('n','<C-p>', '<CMD>lua require("telescope.builtin").git_files()<CR>',opts)
    map('n','<Leader>pf','<CMD>lua require("telescope.builtin").find_files()<CR>',opts)
    map('n','<leader>pw','<CMD>lua require("telescope.builtin").grep_string { search = vim.fn.expand("<cword>") }<CR>',opts)
    map('n','<leader>pb','<CMD>lua require("telescope.builtin").buffers()<CR>',opts)
    map('n','<leader>ph','<CMD>lua require("telescope.builtin").help_tags()<CR>',opts)
    map('n','<leader>fb','<CMD>lua require("telescope.builtin").file_browser()<CR>',opts)
    map('n', '<leader>gwt', '<CMD>lua require("telescope").extensions.git_worktree.git_worktrees()<CR>', opts)
    map('n', '<leader>lca', '<CMD>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)
    map('v', '<leader>lca', '<CMD>lua require("telescope.builtin").lsp_code_actions()<CR>', opts)

end

return {
    init = init
}
