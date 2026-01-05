return {
  cmd = { vim.fn.exepath('biome') or 'biome', 'lsp-proxy' },
  filetypes = { 'javascript', 'javascriptreact', 'json', 'jsonc', 'typescript', 'typescript.tsx', 'typescriptreact' },
  root_markers = { 'biome.json', 'biome.jsonc' },
  on_attach = function(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.format({
          bufnr = bufnr,
          filter = function(c)
            return c.name == 'biome'
          end,
        })
      end,
    })
  end,
}
