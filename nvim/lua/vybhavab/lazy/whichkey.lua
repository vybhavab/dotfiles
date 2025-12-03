return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    plugins = {
      marks = true,
      registers = true,
      spelling = { enabled = false },
    },
    win = {
      border = "rounded",
    },
    spec = {
      { "<leader>v", group = "LSP" },
      { "<leader>p", group = "Project" },
      { "<leader>t", group = "Tabs" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
