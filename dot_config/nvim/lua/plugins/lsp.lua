return {
  {
    "mason-lspconfig.nvim",
    -- LSP servers come from mise (PATH); never auto-install via mason.
    opts = { ensure_installed = {} },
  },
  {
    "mason.nvim",
    -- All tools come from mise (shared disk); mason stays as a viewer only.
    -- function opts: lazy merges ancestors' ensure_installed as a union, so a
    -- plain {} never clears LazyVim core (stylua/shfmt) + extras lists.
    opts = function(_, opts)
      opts.ensure_installed = {}
      return opts
    end,
  },
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

      -- lua-language-server via mise (shared disk), not mason
      opts.servers.lua_ls = opts.servers.lua_ls or {}
      opts.servers.lua_ls.mason = false
      opts.servers.lua_ls.cmd = { "lua-language-server" }

      -- marksman via mise (shared disk), not mason
      opts.servers.marksman = opts.servers.marksman or {}
      opts.servers.marksman.mason = false
      opts.servers.marksman.cmd = { "marksman" }
    end,
  },
}
