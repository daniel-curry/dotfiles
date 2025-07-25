local function smart_cr()
  -- autopairs is always available
  local npairs = require("nvim-autopairs")

  -- cmp *should* be disabled here, but be defensive:
  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok and cmp.visible() then
    return cmp.confirm({ select = false })
  end

  -- let autopairs handle newline inside (), [], "" …
  local keys = npairs.autopairs_cr()
  if keys and #keys > 0 then
    return keys
  end

  -- finally, plain newline + new bullet
  return vim.api.nvim_replace_termcodes(
    "<CR><cmd>AutolistNewBullet<CR>", true, false, true)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "norg" },
  callback = function()
    vim.keymap.set("i", "<CR>", smart_cr,
      { expr = true, buffer = true, silent = true })
  end,
})

