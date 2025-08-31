return {
  "github/copilot.vim",
  config = function()
    -- Recommended: disable copilot in certain filetypes
    vim.g.copilot_filetypes = {
      ["TelescopePrompt"] = false,
      ["NvimTree"] = false,
      ["dap-repl"] = false,
    }

    -- Optional: Map <Tab> to accept copilot suggestion (fallback to normal tab otherwise)
    vim.api.nvim_set_keymap(
      "i",
      "<Tab>",
      'copilot#Accept("<CR>")',
      { silent = true, expr = true, noremap = true }
    )

    -- Optional tweaks
    vim.g.copilot_no_tab_map = true    -- prevent default <Tab> mapping
    vim.g.copilot_assume_mapped = true -- allows custom mapping like above
  end,
}

