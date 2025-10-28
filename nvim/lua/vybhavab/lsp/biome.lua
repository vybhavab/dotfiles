return {
  cmd = { vim.fn.exepath('biome') or 'biome', 'lsp-proxy' },
  filetypes = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'typescript', 'typescript.tsx', 'typescriptreact' },
  root_markers = { 'biome.json', 'biome.jsonc' },
  on_attach = function(client, bufnr)
    local should_write = false
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        if should_write then
          should_write = false
          return
        end
        vim.lsp.buf.code_action({
          context = { only = { 'source.fixAll.biome' } },
          apply = true,
        })
        vim.defer_fn(function()
          if vim.api.nvim_buf_is_valid(bufnr) then
            should_write = true
            vim.cmd('silent write')
          end
        end, 100)
      end,
    })
  end,
}
