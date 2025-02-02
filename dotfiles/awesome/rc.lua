-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
require("awful.hotkeys_popup.keys")

local qubes = require("qubes")


-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")


-- This is used later as the default terminal and editor to run.
terminal = "xterm"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}

mylauncher = awful.widget.launcher({ image = '/usr/share/icons/hicolor/16x16/apps/qubes-logo-icon.png',
                                     command = 'qubes-app-menu' })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  c:emit_signal(
                                                      "request::activate",
                                                      "tasklist",
                                                      {raise = true}
                                                  )
                                              end
                                          end),
                     awful.button({ }, 3, function()
                                              awful.menu.client_list({ theme = { width = 250 } })
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

local qubes_scripts = {
    execute_command_to_active_vm = '/opt/qubes-tools/execute_command_to_active_vm.py',
    open_application_in_active_window = '/opt/qubes-tools/open_application_in_active_window.py',
    open_application_in_template_of_active_window = '/opt/qubes-tools/open_application_in_template_of_active_window.py',
};

-- {{{ Key bindings
globalkeys = gears.table.join(
    --[[ 
    -- Standard program
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),


    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                    c:emit_signal(
                        "request::activate", "key.unminimize", {raise = true}
                    )
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().mypromptbox:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().mypromptbox.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"}),
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),
              ]]--

    -- Reload awesome
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),

    -- Screenshots
    awful.key({ modkey, },            "s",     function ()
        awful.spawn('/opt/qubes-tools/take_dom0_flameshot_screnshot_and_send_to_active_vm.py')
    end,
              {description = "take flameshot screenshot of all screens and send to current vm", group = "launcher"}),





    -- Rofi
    awful.key({ modkey, },            "space",     function ()
        awful.spawn("rofi -columns 2 -fullscreen -show-icons -show drun")
    end,
              {description = "application selector", group = "launcher"}),

    awful.key({ modkey, "Shift" },            "space",     function ()
        awful.spawn("rofi -show-icons -show window")
    end,
              {description = "window selector", group = "launcher"}),


    -- Show settings of current vm
    awful.key({ modkey, "Control" },            "s",     function ()
        awful.spawn(qubes_scripts.execute_command_to_active_vm .. ' "qubes-vm-settings <--Name-->"')
    end,
              {description = "display settings for current qube", group = "launcher"}),


    -- Power off current vm
    awful.key({ modkey, "Control" },            "q",     function ()
        awful.spawn(qubes_scripts.execute_command_to_active_vm .. ' "qvm-shutdown <--Name-->"')
    end,
              {description = "shutdown current vm", group = "launcher"}),


    -- Launching Browsers
    awful.key({ modkey, "Shift" },            "b",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " 'qvm-run -q -a --service --dispvm=ikea-browser -- qubes.StartApp+brave-browser' brave-browser")
    end,
              {description = "open brave browser on current vm", group = "launcher"}),

    awful.key({ modkey, "Control", "Shift" },            "b",     function ()
        awful.spawn("qvm-run -q -a --service --dispvm=ikea-browser -- qubes.StartApp+brave-browser")
    end,
              {description = "open new brave browser in disposable", group = "launcher"}),

    awful.key({ modkey },            "b",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " 'qvm-run -q -a --dispvm=ikea-browser --no-shell librewolf --private-window' librewolf")
    end,
              {description = "open librewolf on current vm", group = "launcher"}),

    awful.key({ modkey, "Control" },            "b",     function ()
        awful.spawn("qvm-run -q -a --dispvm=ikea-browser --no-shell librewolf --private-window")
    end,
              {description = "open librewolf in disposable", group = "launcher"}),

    awful.key({ modkey },            "x",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " 'qvm-run -q -a --dispvm=ikea-browser --no-shell mullvad-browser --private-window' mullvad-browser")
    end,
              {description = "open mullvad browser on current vm", group = "launcher"}),

    awful.key({ modkey, "Control" },            "X",     function ()
        awful.spawn("qvm-run -q -a --dispvm=ikea-browser --no-shell mullvad-browser --private-window")
    end,
              {description = "open mullvad browsder in disposable", group = "launcher"}),




    -- Launching terminal
    awful.key({ modkey },            "Return",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " xterm xterm")
    end,
              {description = "launch terminal in current vm", group = "launcher"}),

    awful.key({ modkey, "Shift" },            "Return",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " xterm xterm root")
    end,
              {description = "launch terminal in current vm as root", group = "launcher"}),

    awful.key({ modkey, "Control" },            "Return",     function ()
        awful.spawn(qubes_scripts.open_application_in_template_of_active_window .. " xterm xterm")
    end,
              {description = "launch terminal in template of current vm", group = "launcher"}),


    -- Launching file manager
    awful.key({ modkey, "Shift" },            "e",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " thunar thunar root")
    end,
              {description = "launch thunar as root in current vm", group = "launcher"}),

    awful.key({ modkey },            "e",     function ()
        awful.spawn(qubes_scripts.open_application_in_active_window .. " thunar thunar")
    end,
              {description = "launch thunar as root in current vm", group = "launcher"}),




    -- Launching pulsemixer with xterm
    awful.key({ modkey, },            "p",     function ()
        awful.spawn("xterm -e /opt/pulsemixer")
    end,
              {description = "launch pulsemixer inside terminal", group = "launcher"}),


    -- Logout menu
    awful.key({ modkey, "Control", "Mod1"},            "q",     function ()
        awful.spawn("xfce4-session-logout")
    end,
              {description = "logout menu", group = "launcher"}),


    -- Lock screen
    awful.key({ modkey, "Control", "Mod1"},            "l",     function ()
        awful.spawn("xflock4")
    end,
              {description = "lock screen", group = "launcher"}),

    -- Monitor movement
    -- TODO: https://devrandom.ro/blog/2022-awesome-window-manager-hacks.html
    -- TODO: client.focus.global_bydirection(dir, c)
    --

    -- Increase or decrease number of masters (rows a lot of layouts)
    awful.key({ modkey  }, "m",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "m",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),

    -- Increase or decrease number of columns
    awful.key({ modkey }, "c",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Shift" }, "c",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"})
)

clientkeys = gears.table.join(
    -- Toggle fullscreen
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),

    -- Toggle floating
    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),


    -- Navigation
    awful.key({ modkey, }, "j", function () awful.client.focus.bydirection("down")    end,
              {description = "go to down client", group = "client"}),
    awful.key({ modkey, }, "k", function () awful.client.focus.bydirection("up")    end,
              {description = "go to up client", group = "client"}),
    awful.key({ modkey, }, "h", function () awful.client.focus.bydirection("left")    end,
              {description = "go to left client", group = "client"}),
    awful.key({ modkey, }, "l", function () awful.client.focus.bydirection("right")    end,
              {description = "go to right client", group = "client"}),

    -- Move windows
    awful.key({ modkey, "Control"   }, "k", function () awful.client.swap.global_bydirection("up")    end,
              {description = "swap with up client", group = "client"}),
    awful.key({ modkey, "Control"   }, "j", function () awful.client.swap.global_bydirection("down")    end,
              {description = "swap with down client", group = "client"}),
    awful.key({ modkey, "Control"   }, "h", function () awful.client.swap.global_bydirection("left")    end,
              {description = "swap with left client", group = "client"}),
    awful.key({ modkey, "Control"   }, "l", function () awful.client.swap.global_bydirection("right")    end,
              {description = "swap with right client", group = "client"}),

    -- Resize windows
    awful.key({ modkey, "Shift"           }, "l",      function (c)
        if c.floating then
            c:relative_move( 0, 0, 10, 0)
        else
            awful.tag.incmwfact(0.025)
        end
    end,
              {description = "Resize Horizontal +", group = "client"}),

    awful.key({ modkey, "Shift"           }, "h",      function (c)
        if c.floating then
            c:relative_move( 0, 0, -10, 0)
        else
            awful.tag.incmwfact(-0.025)
        end
    end,
              {description = "Resize Horizontal -", group = "client"}),

    awful.key({ modkey, "Shift"           }, "j",      function (c)
        if c.floating then
            c:relative_move( 0, 0, 0, -10)
        else
            awful.client.incwfact(0.075)
        end
    end,
              {description = "Resize Vertical -", group = "client"}),

    awful.key({ modkey, "Shift"           }, "k",      function (c)
        if c.floating then
            c:relative_move( 0, 0, 0, 10)
        else
            awful.client.incwfact(-0.075)
        end
    end,
              {description = "Resize Vertical +", group = "client"}),


    -- Focus monitors
    awful.key({ modkey, }, ",", function () awful.screen.focus_bydirection("left") end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, }, ".", function () awful.screen.focus_bydirection("right") end,
              {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey, "Shift" }, ".", function (c) c:move_to_screen(c.screen.index+1) end,
              {description = "move current window to next screen", group = "screen"}),
    awful.key({ modkey, "Shift" }, ",", function (c) c:move_to_screen(c.screen.index-1) end,
              {description = "move current window to next screen", group = "screen"}),



    -- Cycle layouts
    awful.key({ modkey,           }, "Tab", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "Tab", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    -- Close window
    awful.key({ modkey,            }, "w",      function (c) c:kill()                         end,
              {description = "close", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "qubes-app-menu",
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
          "pinentry",
        },
        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "ConfigManager",  -- Thunderbird's about:config.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    qubes.manage(c)
    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    qubes.manage(c)
    awful.titlebar(c, { bg_normal = qubes.get_colour(c),
                        bg_focus = qubes.get_colour_focus(c) } ) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Put the Qube name in front of all displayed names (tilebars, tasklists, ...)
client.connect_signal("property::name", function(c) qubes.set_name(c) end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = qubes.get_colour_focus(c) end)
client.connect_signal("unfocus", function(c) c.border_color = qubes.get_colour(c) end)
-- }}}

-- Use dex to run the xdg autostart files
-- for now run the ones for XFCE
awful.spawn('bash -c "pgrep -f -a qvm-start-daemon | grep -v $$ || dex-autostart -a -e XFCE"')
