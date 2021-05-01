lua require("vybhavb")

nnoremap <leader>a :lua require("harpoon.mark").add_file()<CR>
nnoremap <C-h> :lua require("harpoon.ui").nav_file(1)<CR>
nnoremap <C-j> :lua require("harpoon.ui").nav_file(2)<CR>
nnoremap <C-k> :lua require("harpoon.ui").nav_file(3)<CR>
nnoremap <C-l> :lua require("harpoon.ui").nav_file(4)<CR>
nnoremap <C-y> :lua require("harpoon.mark").rm_file()<CR>

nnoremap <leader><C-s> :lua require("harpoon.mark").shorten_list()<CR>
nnoremap <leader><C-d> :lua require("harpoon.mark").clear_all()<CR>
nnoremap <leader>r :lua require("harpoon.mark").promote()<CR>

nnoremap <leader>ts :lua require("harpoon.term").gotoTerminal(1)<CR>
nnoremap <leader>td :lua require("harpoon.term").gotoTerminal(2)<CR>
nnoremap <leader>cs :lua require("harpoon.term").sendCommand(1, 1)<CR>
nnoremap <leader>cd :lua require("harpoon.term").sendCommand(2, 2)<CR>
