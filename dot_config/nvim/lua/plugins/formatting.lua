return {
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.default_format_opts = {
        timeout_ms = 500,
        lsp_fallback = "never",
      }

      opts.formatters_by_ft = {
        tablegen = { "clang-format" },
        cpp = { "clang-format" },
        c = { "clang-format" },
        ["*"] = { "trim_whitespace" },
      }

      opts.formatters = opts.formatters or {}
      opts.formatters["clang-format"] = {
        condition = function(_, ctx)
          local has_gitsigns, gitsigns = pcall(require, "gitsigns")
          if not has_gitsigns then
            return false
          end

          local hunks = gitsigns.get_hunks(ctx.bufnr)
          if hunks == nil then
            return true -- untracked new file
          end
          if #hunks == 0 then
            return false
          end

          return true
        end,

        args = function(_, ctx)
          local ext = vim.fn.fnamemodify(ctx.filename, ":e")
          local style = "{ColumnLimit: 80, AllowShortIfStatementsOnASingleLine: WithoutElse}"

          if ext == "td" or ctx.filetype == "tablegen" then
            style = "{ColumnLimit: 80, AllowShortIfStatementsOnASingleLine: WithoutElse}"
          end

          local args = {
            "--assume-filename=" .. ctx.filename,
            "--style=" .. style,
          }

          local gitsigns = require("gitsigns")
          local hunks = gitsigns.get_hunks(ctx.bufnr)

          if hunks and #hunks > 0 then
            for _, hunk in ipairs(hunks) do
              table.insert(args, string.format("--lines=%d:%d", hunk.added.start, hunk.added.start + hunk.added.count))
            end
          end

          return args
        end,
      }
    end,
  },
}
