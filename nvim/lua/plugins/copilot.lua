return {
  "github/copilot.vim",
  config = function()
    -- Disable copilot in certain filetypes
    vim.g.copilot_filetypes = {
      ["TelescopePrompt"] = false,
      ["NvimTree"] = false,
      ["dap-repl"] = false}

    vim.api.nvim_set_keymap("i","<C-L>",'copilot#Accept("<CR>")',
      { silent = true, expr = true, noremap = true })
    vim.api.nvim_set_keymap("i","<C-J>",'copilot#Next()',
      { silent = true, expr = true, noremap = true })
    vim.api.nvim_set_keymap("i","<C-K>",'copilot#Previous()',
      { silent = true, expr = true, noremap = true })

    vim.g.copilot_no_tab_map = true    -- prevent default <Tab> mapping
    vim.g.copilot_assume_mapped = true -- allows custom mapping like above
    vim.g.copilot_enabled = false -- disable Copilot by default
  end,
}
