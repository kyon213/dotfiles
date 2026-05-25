return {
  {
    "saghen/blink.cmp",
    opts = {
      keymap = {
        preset = "enter",

        ["<CR>"] = { "fallback" },

        ["<Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_next({ behavior = "insert" })
            else
              return cmp.sinppet_forward()
            end
          end,
          "fallback",
        },

        ["<S-Tab>"] = {
          function(cmp)
            if cmp.is_visible() then
              return cmp.select_prev({ behavior = "insert" })
            else
              return cmp.snippet_backward()
            end
          end,
          "fallback",
        },
      },
    },
  },
}
