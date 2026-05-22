return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}

      opts.servers.clangd = opts.servers.clangd or {}
      opts.servers.clangd.mason = false

      opts.servers.clangd.cmd = opts.servers.clangd.cmd or { "clangd" }
      local my_args = {
        "--header-insertion=never", -- optional: iwyu (include what you use)
        "--malloc-trim", -- avoid OOM
        "-j=4", -- limit total threads
      }
      for _, arg in ipairs(my_args) do
        table.insert(opts.servers.clangd.cmd, arg)
      end
    end,
  },
}
