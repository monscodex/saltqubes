-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Shortened function name
local map = LazyVim.safe_keymap_set

local function apply_keymap_for_different_keys(mode, base_activator, base_command, keys, opts)
  for _, key in ipairs(keys) do
    local activator = string.format(base_activator, key)
    local command = string.format(base_command, key)

    map(mode, activator, command, opts)
  end
end

local function main()
  local options = { noremap = true }

  -- Modes
  --   normal_mode = "n",
  --   insert_mode = "i",
  --   visual_mode = "v",
  --   visual_block_mode = "x",
  --   term_mode = "t",
  --   command_mode = "c",

  -- Faster quit to normal mode
  local kj_remap_modes = { "i", "v", "x", "c" }

  for _, mode in ipairs(kj_remap_modes) do
    map(mode, "kj", "<C-c>", options)
    map(mode, "KJ", "<C-c>", options)
  end

  -- Undo break points (When inserting text we want undo breakpoints to avoid going back to normal mode and doing undo)
  local break_points = { "[", "]", "(", ")", ",", ".", "!", "?", ">", "<", "=" }
  for _, break_point in ipairs(break_points) do
    map("i", break_point, break_point .. "<c-g>u", options)
  end

  --  Window managing  --
  local silent_options = { noremap = true, silent = true }

  -- This is a way to reload certain lsp conmpletions
  -- map("i", "<M-Space>", "<Esc>a<C-Space>", silent_options)

  -- Better window navigation
  -- lvim.keys.normal_mode["M-j"] = false
  -- lvim.keys.normal_mode["M-k"] = false
  local movement_keys = { "k", "j", "l", "h" }
  apply_keymap_for_different_keys("n", "<M-%s>", ":wincmd %s<CR>", movement_keys, silent_options) -- Normal windows

  map("n", "<C-j>", ":resize -2<CR>", silent_options)
  map("n", "<C-k>", ":resize +2<CR>", silent_options)
  map("n", "<C-l>", ":vertical resize -2<CR>", silent_options)
  map("n", "<C-h>", ":vertical resize +2<CR>", silent_options)
  map("n", "<C-=>", "<C-w>=", silent_options) -- Resize all windows to the same size

  --  Better moving in Command mode & Insert mode  --
  map("c", "<C-j>", "<C-n>", options)
  map("c", "<C-k>", "<C-p>", options)
  map("c", "<C-h>", "<Left>", options)
  map("c", "<C-l>", "<Right>", options)

  --  Disable cutting when deleting in x and dw  --
  map("n", "x", '"_x', options)
  map("x", "x", '"_x', options)
  map("n", "dw", '"_dw', options)
  map("x", "dw", '"_dw', options)
end

main()
