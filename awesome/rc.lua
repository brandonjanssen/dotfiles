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
terminal = "kitty"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
local modkey       = "Mod4"
local altkey       = "Mod1"
local modkey1      = "Control"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    -- awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
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

menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

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
    awful.tag({ "WEB", "PIC", "TER", "FILE", "ROFI", "DEX", "CODE", "DIS", "TWI" }, s, awful.layout.layouts[1])
    -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])


end)
-- }}}

-- {{{ Mouse bindings
-- root.buttons(gears.table.join(
--     awful.button({ }, 3, function () mymainmenu:toggle() end),
--     awful.button({ }, 4, awful.tag.viewnext),
--     awful.button({ }, 5, awful.tag.viewprev)
-- ))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="Help"}),
    -- awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
    --           {description = "view previous", group = "tag"}),
    -- awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
    --           {description = "view next", group = "tag"}),
    -- awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
    --           {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --           {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey,"Shift"   }, "l", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "Layout"}),

    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),

    -- awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
    --           {description = "focus the next screen", group = "screen"}),

    -- awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
    --           {description = "focus the previous screen", group = "screen"}),

    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
            {description = "jump to urgent client", group = "client"}),

    -- awful.key({ modkey,           }, "Tab",
    --     function ()
    --         awful.client.focus.history.previous()
    --         if client.focus then
    --             client.focus:raise()
    --         end
    --     end,
    --     {description = "go back", group = "client"}),

    -- Brightness
    awful.key({ }, "XF86MonBrightnessUp", function () os.execute("light -A 10") end,
            {description = "+10%", group = "hotkeys"}),
    awful.key({ }, "XF86MonBrightnessDown", function () os.execute("light -U 10") end,
            {description = "-10%", group = "hotkeys"}),

    awful.key({}, "XF86AudioRaiseVolume", function () awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%+", false) end),
    awful.key({}, "XF86AudioLowerVolume", function () awful.util.spawn("wpctl set-volume @DEFAULT_AUDIO_SINK@ 3%-", false) end),
    awful.key({}, "XF86AudioMute", function () awful.util.spawn("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", false) end),

    --Media keys supported by vlc, spotify, audacious, xmm2, ...
    --awful.key({}, "XF86AudioPlay", function() awful.util.spawn("playerctl play-pause", false) end),
    --awful.key({}, "XF86AudioNext", function() awful.util.spawn("playerctl next", false) end),
    --awful.key({}, "XF86AudioPrev", function() awful.util.spawn("playerctl previous", false) end),
    --awful.key({}, "XF86AudioStop", function() awful.util.spawn("playerctl stop", false) end),

--Media keys supported by mpd.
    -- awful.key({}, "XF86AudioPlay", function () awful.util.spawn("mpc toggle") end),
    -- awful.key({}, "XF86AudioNext", function () awful.util.spawn("mpc next") end),
    -- awful.key({}, "XF86AudioPrev", function () awful.util.spawn("mpc prev") end),
    -- awful.key({}, "XF86AudioStop", function () awful.util.spawn("mpc stop") end),    

    --kitty
    awful.key({ modkey,   }, "Return", function() awful.util.spawn("kitty -e fish") end,
        {description = "kitty", group = "Terminal"}),  
        
    awful.key({ modkey,   }, "m", function() awful.util.spawn("kitty -e mocp") end,
        {description = "moc", group = "Music"}),  
        
    --File Managers
    --Ranger
    awful.key({ modkey, "Shift"  }, "t", function() awful.util.spawn( "kitty -e ranger") end,
        {description = "Ranger", group = "File Manager"}),

    awful.key({ modkey, "Shift"  }, "n", function () awful.util.spawn( "kitty -e nnn" ) end,
        {description = "NNN" , group = "File Manager" }),

    awful.key({ modkey, }, "t", function () awful.util.spawn( "thunar" ) end,
        {description = "Thunar", group = "File Manager"}),  

     -- Rofi Drun
    awful.key({ modkey }, "space", function () awful.util.spawn( "rofi -show drun -show-icons -modi drun,run " ) end,
        {description = "Rofi Drun", group = "Rofi"}),  
    
    --Browser
    --Brave-Browser
    awful.key({ modkey }, "w", function () awful.util.spawn( "google-chrome-stable" ) end,
        {description = "Chrome-Browser", group = "Browser"}), 
        
        --Obsidian
        awful.key({ modkey }, "o", function () awful.util.spawn( "obsidian" ) end,
            {description = "Obsidian", group = "Editor"}), 
    --Logout
    awful.key({ modkey }, "x", function () awful.util.spawn( "/usr/bin/clearine" ) end,
        {description = "Lxsession-Logout", group = "Logout"}), 
        
    --- Wallpaper changer    
        awful.key({ modkey }, "r", function () awful.util.spawn( "feh --randomize --bg-fill /home/dmne/Pictures/background" ) end,
            {description = "Feh Wallpaper Changer", group = "Wallpaper"}), 

    -- Standard program

    awful.key({ modkey, "Shift" }, "r", awesome.restart,
            {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
            {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)          end,
            {description = "increase master width factor", group = "Window Resize"}),

    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)          end,
            {description = "decrease master width factor", group = "Window Resize"}),

    -- awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
    --         {description = "increase the number of master clients", group = "Window Resize"}),

    -- awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
    --         {description = "decrease the number of master clients", group = "Window Resize"}),

    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol( 1, nil, true)    end,
            {description = "increase the number of columns", group = "Window Resize"}),

    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol(-1, nil, true)    end,
            {description = "decrease the number of columns", group = "Window Resize"}),

    awful.key({ modkey,  "Shift"         }, "z", function () awful.layout.inc( 1)                end,
            {description = "select next", group = "Window Resize"}),
    
    awful.key({ modkey, }, "z", function () awful.layout.inc(-1)                end,
            {description = "select previous", group = "Layout"}),

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

    awful.key({ modkey,"Shift" }, "space", function() menubar.show() end,
            {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    -- awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
    --           {description = "close", group = "client"}),
    awful.key({ modkey, },           "q",      function (c) c:kill()                         end,
            {description = "close", group = "KILL Focus"}),
    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle                     ,
            {description = "toggle floating", group = "client"}),
    -- awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
    --           {description = "move to master", group = "client"}),
    -- awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
    --           {description = "move to screen", group = "client"}),
    -- awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
    --           {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "i",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "i",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "i",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
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
        "DTA",  -- Firefox addon DownThemAll.
        "copyq",  -- Includes session name in class.
        "pinentry",
        },
        class = {
            "Arandr",
            "Arcolinux-welcome-app.py",
            "Blueberry",
            "Galculator",
            "SpeedCrunch",
            "Gnome-font-viewer",
            "Gpick",
            "Imagewriter",
            "Font-manager",
            "Kruler",
            "MessageWin",  -- kalarm.
            "arcolinux-logout",
            "Peek",
            "Skype",
            "imager",
            "System-config-printer.py",
            "Sxiv",
            "Deadbeef",
            "Pavucontrol",
            "pavucontrol",
            "blueman-manager",
            "Unetbootin.elf",
            "Wpa_gui",
            "pinentry",
            "veromix",
            "wm-logout",
            "Yad",
            "Imager",
            "Xfce4-appfinder",
            "xtightvncviewer",
            "Xfce4-terminal"
        },

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
    }, properties = { titlebars_enabled = false }
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

    awful.titlebar(c) : setup {
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

---- FLOATING RULES
client.connect_signal("property::floating", function(c)
    if c.floating then
        c.ontop = true
    else
        c.ontop = false
    end
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_width = "2" end)
client.connect_signal("unfocus", function(c) c.border_width = "2" end)
client.connect_signal("focus", function(c) c.border_color = "#3f92f7" end)
client.connect_signal("unfocus", function(c) c.border_color = "#EC8011" end)
-- }}}

beautiful.useless_gap = 7
-- beautiful.gap_single_client = true
-- Autostart applications
awful.spawn.with_shell("/home/dmne/.config/polybar/launch.sh")
-- awful.spawn.with_shell(" picom --experimental-backends")
awful.spawn.with_shell("xdg-user-dirs-update")
-- awful.spawn.with_shell("syncthing")
-- awful.spawn.with_shell(" /usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1")
awful.spawn.with_shell("xrandr --output HDMI-A-0 --mode 1366x768 --rate 59.79 --output eDP --off")
-- awful.spawn.with_shell("cbatticon -u 20 -i notification -c "poweroff" -l 15 -r 10 ")
-- awful.spawn.with_shell("cbatticon  -i notification /sys/class/power_supply/BAT0")
awful.spawn.with_shell("nm-applet")
-- awful.spawn.with_shell("pasystray --notify=all instead ")
awful.spawn.with_shell("blueman-applet")
awful.spawn.with_shell("picom -f")
awful.spawn.with_shell("xmodmap  -e 'clear lock'")
-- awful.spawn.with_shell("~/.config/picom --experimental-backend ")
awful.spawn.with_shell("feh --randomize --bg-fill /home/dmne/Pictures/background ")
awful.spawn.with_shell("/usr/lib/policykit-1-gnome/polkit-gnome-authentication-agent-1 ")
-- awful.spawn.with_shell("volumeicon")
-- awful.spawn.with_shell("nitrogen --restore")

