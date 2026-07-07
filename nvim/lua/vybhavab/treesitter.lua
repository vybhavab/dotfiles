vim.treesitter.language.register("tsx", "typescriptreact")
vim.treesitter.language.register("javascript", "javascriptreact")

vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("VybhavABTreesitter", { clear = true }),
  callback = function(event)
    if vim.bo[event.buf].buftype ~= "" then
      return
    end

    local filetype = vim.bo[event.buf].filetype
    local lang = vim.treesitter.language.get_lang(filetype) or filetype
    if not vim.treesitter.language.add(lang) then
      vim.bo[event.buf].syntax = "ON"
      return
    end

    local ok = pcall(vim.treesitter.start, event.buf, lang)
    if not ok then
      vim.bo[event.buf].syntax = "ON"
    end
  end,
})
