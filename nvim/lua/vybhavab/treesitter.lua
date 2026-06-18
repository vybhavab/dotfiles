vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("VybhavABTreesitter", { clear = true }),
  callback = function(event)
    local ok = pcall(vim.treesitter.start, event.buf)
    if not ok then
      vim.bo[event.buf].syntax = "ON"
    end
  end,
})
