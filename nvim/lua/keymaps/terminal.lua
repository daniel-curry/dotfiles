local map = vim.keymap.set -- set alias 'map' instead of verbose vim.keymap.set
map("n", "<leader>t", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" }) -- Space + t maps to ToggleTerminal




-- Auto-Run programs based off filetype:

local function run_file()
  local filetype = vim.bo.filetype
  local file = vim.fn.expand("%")
  local file_noext = vim.fn.expand("%:r")
  local file_noext_full = vim.fn.expand("%:p:r")
  local cmd

  -- For C and C++: always run the CMake interactive script
  if filetype == "c" or filetype == "cpp" then
    cmd = "run_select.sh"
  else
    local runners = {
      python = "python3 %",
      lua    = "lua %",
      javascript = "node %",
      typescript = "ts-node %",
      sh     = "bash %",
      rust   = "rustc " .. file .. " && ./" .. file_noext
    }
    cmd = runners[filetype]
    if cmd then
      cmd = cmd:gsub("%%", file)
    end
  end

  if not cmd then
    vim.notify("No runner for filetype: " .. filetype, vim.log.levels.WARN)
    return
  end

  local ok, term_mod = pcall(require, "toggleterm.terminal")
  if not ok then
    vim.notify("toggleterm.nvim not loaded", vim.log.levels.ERROR)
    return
  end
  local Terminal = term_mod.Terminal

  vim.notify("Running: " .. cmd)
  local term = Terminal:new({ cmd = cmd, direction = "horizontal", close_on_exit = false })
  term:toggle()
end

vim.keymap.set("n", "<leader>r", run_file, { desc = "Run current file" })

