noremap <leader>tp :tabp<CR>
nnoremap <leader>tn :tabn<CR>
nnoremap <leader>nt :tabnew<CR>

nnoremap <leader>h :wincmd h<CR>
nnoremap <leader>j :wincmd j<CR>
nnoremap <leader>k :wincmd k<CR>
nnoremap <leader>l :wincmd l<CR>

" Quick Fix Lists
let g:qf_l = 0
let g:qf_g = 0

fun! ToggleQFList(global)
    if g:qf == 1
        if a:global
            let g:qf_g = 0
            cclose
        else
            let g:qf_l = 0
            lclose
        endif
    else
        if a:global
            let g:qf_g = 0
            cclose
        else
            let g:qf_l = 0
            lclose
        endif
    endif
endfun


" nnoremap <C-k> :cnext<CR>
" nnoremap <C-j> :cprev<CR>
" nnoremap <C-q> :call ToggleQFList(1)<CR>
" nnoremap <C-w> :call ToggleQFList(0)<CR>
