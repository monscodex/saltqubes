local options = {
	-- Search options
	hlsearch = true,
	ignorecase = true,
	incsearch = true,
	inccommand = "nosplit",                        -- highlight :%s search
	smartcase = true,                        -- apply smartcase to search (search for exact case if there is an uppercase letter)
	syntax = "enable",
	-- UI options
	cmdheight = 2,
	history = 1000,
	termguicolors = true,
	scrolloff = 10,
	sidescrolloff = 10,
	guifont = "monospace:h17",
	numberwidth = 4,                         -- set number column width to 4
	signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
	background = "dark",
	list = true,                             -- show hidden characters
	laststatus = 3,                          -- Always show statusline
	conceallevel = 0,                        -- so that `` is visible in markdown files
	-- Intuitive splitting
	splitbelow = true,
	splitright = true,
	--Spell
	spell = false, -- Using linter instead
	-- Tab vs Spaces options
	showtabline = 0,
	expandtab = true,                        -- convert tabs to spaces
	tabstop = 4,                             -- insert 4 spaces for a tab
	shiftwidth = 4,                          -- the number of spaces inserted for each indentation
	-- Indenting options
	smartindent = true,                      -- make indenting smarter again
	-- autoindent = true,
	-- Backup files configurations
	swapfile = false,
	writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	undofile = true,                         -- enable persistent undo
	backup = false,
	-- Timing
	updatetime = 100,                         -- faster completion (4000ms default)
	timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
	-- Cursor
	cursorline = false,                       -- highlight the current line
	ruler = false,                            -- show the cursor's position at the bottom of the screen
	relativenumber = true,
	number = true,
	-- Wrap
	wrap = false,
	-- Buffer
	hidden = true,                           -- sync visual modifications to two opened instances of the same buffer
	-- Miscellaneous
	shell = "/bin/bash",                     -- avoid this error https://github.com/kyazdani42/nvim-tree.lua/issues/549
	clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
	encoding = "utf-8",
	fileencoding = "utf-8",
	mouse = "a",                             -- allow the mouse to be used in neovim
}


for key, value in pairs(options) do
	vim.opt[key] = value
end

vim.cmd [[colorscheme torte]]
vim.cmd [[hi Comment guifg=#ff5e7e]]

vim.cmd [[set undodir=/etc/nvim/undodir]]
vim.cmd [[set path+=**]] -- search directories recursively
vim.cmd [[set iskeyword+=-]]
vim.cmd [[set formatoptions-=cro]]
vim.cmd [[filetype plugin on]]
vim.cmd [[
augroup salt_syn
  au BufNewFile,BufRead *.sls set filetype=sls.yaml
augroup END
]]

-- KEYMAPS

-- Shortened function name
local keymap = vim.api.nvim_set_keymap

local function apply_keymap_for_different_keys(mode, base_activator, base_command, keys, opts)
	for _, key in ipairs(keys) do
		local activator = string.format(base_activator, key)
		local command = string.format(base_command, key)

		keymap(mode, activator, command, opts)
	end
end

local function setup_keymaps()
	local options = { noremap = true }

	-- Remap space as leader key
	keymap("n", "<Space>", "", options)
	vim.g.mapleader = " "
	vim.g.maplocalleader = " "

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
		keymap(mode, "kj", "<C-c>", options)
		keymap(mode, "KJ", "<C-c>", options)
	end

	-- Undo break points (When inserting text we want undo breakpoints to avoid going back to normal mode and doing undo)
	local break_points = { "[", "]", "(", ")", ",", ".", "!", "?", ">", "<", "=" }
	for _, break_point in ipairs(break_points) do
		keymap("i", break_point, break_point .. "<c-g>u", options)
	end


	--  Window managing  --
	local silent_options = { noremap = true, silent = true }

	-- Better window navigation
	local movement_keys = { "k", "j", "l", "h" }
	apply_keymap_for_different_keys("n", "<M-%s>", ":wincmd %s<CR>", movement_keys, silent_options) -- Normal windows

	-- Move windows
	local move_windows_keys = { "K", "J", "L", "H" }
	apply_keymap_for_different_keys("n", "<M-%s>", ":wincmd %s<CR>", move_windows_keys, silent_options)

	-- Resize windows
	keymap("n", "<C-j>", ":resize -2<CR>", silent_options)
	keymap("n", "<C-k>", ":resize +2<CR>", silent_options)
	keymap("n", "<C-l>", ":vertical resize -2<CR>", silent_options)
	keymap("n", "<C-h>", ":vertical resize +2<CR>", silent_options)
	keymap("n", "<C-=>", "<C-w>=", silent_options) -- Resize all windows to the same size

	--  Better moving in Command mode & Insert mode  --
	keymap("c", "<C-j>", "<C-n>", options)
	keymap("c", "<C-k>", "<C-p>", options)
	keymap("c", "<C-h>", "<Left>", options)
	keymap("c", "<C-l>", "<Right>", options)

	--  Disable cutting when deleting in x and dw  --
	keymap("n", "x", '"_x', options)
	keymap("x", "x", '"_x', options)
	keymap("n", "dw", '"_dw', options)
	keymap("x", "dw", '"_dw', options)
  
  -- Quitting
  keymap("n", "<leader>w", ":w<cr>", options)
  keymap("n", "<leader>q", ":conf q<cr>", options)

  -- Indenting
  keymap("v", "<", "<gv", options)
  keymap("v", ">", ">gv", options)

  -- Terminal
  keymap("t", "jk", "<C-\\><C-n>", options)
  keymap("n", "tv", ":vsplit term:///usr/bin/fish<cr>i", options)
  keymap("n", "ts", ":split term:///usr/bin/fish<cr>i", options)

end


setup_keymaps()
