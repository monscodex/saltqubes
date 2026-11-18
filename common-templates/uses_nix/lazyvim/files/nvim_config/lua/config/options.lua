-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local options = {
  -- UI options
  history = 1000, -- Set a large history
  scrolloff = 8, -- large scrolloff
  sidescrolloff = 8, -- large scrollof
  numberwidth = 4, -- set number column width to 4
  list = true, -- show hidden characters
  conceallevel = 0, -- so that `` is visible in markdown files
  --Spell
  spell = false, -- Using linter instead
  -- Backup files configurations
  swapfile = false, -- creates a swapfile
  writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  undofile = true, -- enable persistent undo
  backup = false, -- creates a backup file
  -- Timing
  updatetime = 100, -- faster completion (4000ms default)
  timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
  -- Cursor
  cursorline = true, -- highlight the current line
  ruler = true, -- show the cursor's position at the bottom of the screen
  relativenumber = true, -- relativenumber followed by number shows both of them
  number = true, -- relativenumber followed by number shows both of them
  -- Wrap
  wrap = false, -- display lines as one long line
  -- Buffer
  hidden = true, -- sync visual modifications to two opened instances of the same buffer
  -- Miscellaneous
  shell = "/bin/bash", -- avoid this error https://github.com/kyazdani42/nvim-tree.lua/issues/549
}

for key, value in pairs(options) do
  vim.opt[key] = value
end

vim.cmd([[set undodir=~/.local/share/neovim-undodir]])
