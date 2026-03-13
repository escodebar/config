vim.lsp.enable({
  "bashls",
  "nixd",
  "pyright",
  "ts_ls",
})
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
