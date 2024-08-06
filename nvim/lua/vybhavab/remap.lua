vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", "<CMD>Ex<CR>")
vim.keymap.set('n', '<leader>h', '<CMD>wincmd h<CR>')
vim.keymap.set('n', '<leader>j', '<CMD>wincmd j<CR>')
vim.keymap.set('n', '<leader>k', '<CMD>wincmd k<CR>')
vim.keymap.set('n', '<leader>l', '<CMD>wincmd l<CR>')
vim.keymap.set('n', '<leader>tp', '<CMD>tabp<CR>')
vim.keymap.set('n', '<leader>tn', '<CMD>tabn<CR>')
vim.keymap.set('n', '<leader>nt', '<CMD>tabnew<CR>')

vim.keymap.set('n', '<silent> <leader>+', '<CMD>exe "resize " . (winheight(0) * 3/2)<CR>')
vim.keymap.set('n', '<silent> <leader>-', '<CMD>exe "resize " . (winheight(0) * 2/3)<CR>')

vim.keymap.set('n', '<leader>w', '<CMD>w<CR>')
vim.keymap.set('n', '<leader>x', '<CMD>x<CR>')
vim.keymap.set('n', '<leader>q', '<CMD>q<CR>')

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

vim.keymap.set("n", "J", "mzJ`z")

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>y", [["+y]])
vim.keymap.set("v", "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")

vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)

vim.keymap.set("n", "<C-n>", "<cmd>cnext<CR>zz")
vim.keymap.set("n", "<C-b>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader><leader>", function()
  vim.cmd("so")
end)
