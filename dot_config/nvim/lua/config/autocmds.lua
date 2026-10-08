-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- Keep markdown buffers quiet on open: nvim-lint runs markdownlint-cli2 on BufReadPost and
-- LazyVim renders its MD0xx warnings inline. Suppress *display* for markdown only -- the
-- diagnostics are still produced and stay reviewable on demand
-- (<leader>ud toggle, <leader>xx Trouble, <leader>cd / ]d).
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("user_markdown_diagnostics_quiet", { clear = true }),
  pattern = { "markdown", "markdown.mdx" },
  callback = function()
    vim.diagnostic.enable(false, { bufnr = vim.api.nvim_get_current_buf() })
  end,
})
