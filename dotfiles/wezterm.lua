local wezterm = require 'wezterm'
local act = wezterm.action
local mux = wezterm.mux
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

keys = {
	-- Copy mode
	{ key = 'Enter', mods = 'CTRL',       action = act.ActivateCopyMode, },
	{ key = 'Enter', mods = 'LEADER',       action = act.ActivateCopyMode, },

	-- Font resizing
	{ key = '+',     mods = 'CTRL',       action = act.IncreaseFontSize },
	{ key = '-',     mods = 'CTRL',       action = act.DecreaseFontSize },
	{ key = '0',     mods = 'CTRL',       action = act.ResetFontSize },

	-- Clipboard
	{ key = 'c',     mods = 'SHIFT|CTRL', action = act.CopyTo 'Clipboard' },
	{ key = 'v',     mods = 'CTRL|SHIFT', action = act.PasteFrom 'Clipboard' },

	-- Spawn
	{ key = 'n',     mods = 'CTRL|SHIFT',     action = act.SpawnWindow },
	-- { key = 's',     mods = 'LEADER',     action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
	-- { key = 'v',     mods = 'LEADER',     action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
	{ key = 't',     mods = 'CTRL',     action = act.SpawnTab 'CurrentPaneDomain' },

	-- Close
	-- { key = 'q',     mods = 'LEADER', action = act.CloseCurrentPane { confirm = false } },
	-- {
	-- 	key = 'l',
	-- 	mods = 'CTRL|ALT',
	-- 	action = act.Multiple {
	-- 		act.ClearScrollback 'ScrollbackAndViewport',
	-- 		act.SendKey { key = 'L', mods = 'CTRL' }
	-- 	}
	-- },

	-- Moving panes
	-- { key = 'h',   mods = 'LEADER',     action = act.ActivatePaneDirection 'Left' },
	-- { key = 'l',   mods = 'LEADER',     action = act.ActivatePaneDirection 'Right' },
	-- { key = 'k',   mods = 'LEADER',     action = act.ActivatePaneDirection 'Up' },
	-- { key = 'j',   mods = 'LEADER',     action = act.ActivatePaneDirection 'Down' },

	-- Moving tabs
	-- { key = 'Tab', mods = 'CTRL|SHIFT', action = act.ActivateTabRelative(-1) },
	-- { key = 'Tab', mods = 'CTRL',       action = act.ActivateTabRelative(1) },

	--
};

local mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'NONE',
		action = act.CompleteSelection 'ClipboardAndPrimarySelection',
	},

	-- and make CTRL-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = 'Left' } },
		mods = 'CTRL',
		action = act.OpenLinkAtMouseCursor,
	},
	{
		event = { Down = { streak = 3, button = 'Left' } },
		action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
		mods = 'NONE',
	},
}

return {
	window_decorations = "RESIZE",
	color_scheme = "Tokyo Night",
	hide_tab_bar_if_only_one_tab = true,
	adjust_window_size_when_changing_font_size = false,

	font = wezterm.font('CaskaydiaCove Nerd font Mono'),
	font_size = 10,
	bold_brightens_ansi_colors = true,

	use_dead_keys = false,
	scrollback_lines = 25000,

	disable_default_key_bindings = true,

	leader = { key = 'Space', mods = 'ALT', timeout_milliseconds = 5000 },

	keys = keys,
	mouse_bindings = mouse_bindings,

	default_cursor_style = 'SteadyBar',
}
