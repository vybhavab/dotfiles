return {
  cmd = { vim.fn.exepath('bash-language-server') or 'bash-language-server', 'start' },
  filetypes = { 'sh', 'bash' },
}
