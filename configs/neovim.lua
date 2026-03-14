vim.g.mapleader = ","
vim.keymap.set("n", "gd", vim.lsp.buf.definition)
vim.keymap.set("n", "K", vim.lsp.buf.hover)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
vim.keymap.set("n", "<F1>", ":bprevious<CR>", { silent = true })
vim.keymap.set("n", "<F2>", require("telescope.builtin").buffers, { desc = "Telescope buffers" })
vim.keymap.set("n", "<F3>", ":bdelete<CR>", { silent = true })
vim.keymap.set("n", "<F4>", ":bnext<CR>", { silent = true })
vim.lsp.enable({
  "bashls",
  "nixd",
  "pyright",
  "ts_ls",
})
vim.opt.hidden = true
vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.incsearch = true
vim.opt.laststatus = 3
vim.opt.mouse = "r"
vim.opt.number = true
vim.opt.ruler = true
vim.opt.showmatch = true
vim.opt.showtabline = 2
vim.opt.smartindent = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.timeoutlen = 50
vim.opt.whichwrap:append("<,>,h,l")
vim.opt.wildmenu = true
vim.opt.wildmode = "longest:full"
vim.opt.wrap = true
