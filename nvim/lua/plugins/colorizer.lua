return {
  "uga-rosa/ccc.nvim",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    local ccc = require("ccc")

    ccc.setup({
      highlighter = {
        auto_enable = true,   -- highlight colors automatically
        lsp = true,           -- also get colors from LSP diagnostics
      },
      pickers = {
        ccc.picker.hex,       -- enable hex picker
        ccc.picker.css_rgb,   -- enable rgb()/rgba()
        ccc.picker.css_hsl,   -- enable hsl()/hsla()
      },
    })

    -- optional keymap to launch color picker
    vim.keymap.set("n", "<leader>cp", "<cmd>CccPick<CR>", { desc = "Pick color" })
  end,
}

