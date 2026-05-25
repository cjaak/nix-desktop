package.loaded["naughty.dbus"] = {}

pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
require("awful.ewmh")
local beautiful = require("beautiful")
local naughty = require("naughty")

-- -----------------------------------------------------------------------------
-- Error handling (copied from default)

if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors
    })
end
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err)
        })
        in_error = false
    end)
end


-- -----------------------------------------------------------------------------
-- Init.

awful.layout.layouts = {
    awful.layout.suit.tile
}

awful.screen.connect_for_each_screen(function(s)
    awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }, s, awful.layout.layouts[1])
end)

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local modkey = "Mod4"

beautiful.useless_gap = 3
beautiful.gap_single_client = true
local primary_screen = screen.primary
awful.screen.padding(primary_screen, {
    top = 42,
    left = 8,
    right = 8,
    bottom = 42
})
if screen[2] then
    awful.screen.padding(screen[2], {
        top = 8,
        left = 8,
        right = 8,
        bottom = 42
    })
end

-- -----------------------------------------------------------------------------
-- Keybinds.

local globalkeys = gears.table.join(
    awful.key({ modkey, }, "t", function() awful.spawn("wezterm") end),
    awful.key({ modkey, }, "d", function() awful.spawn("/home/charlie/.config/rofi/apps.sh") end),
    awful.key({ modkey, "Shift" }, "e", function() awful.spawn("/home/charlie/.config/rofi/powermenu/run.sh") end),
    awful.key({ modkey, }, "s", function() awful.spawn("/home/charlie/.config/rofi/tmux.sh") end),
    awful.key({ modkey, }, "b", function() awful.spawn("firefox") end),
    awful.key({ modkey, }, "Tab", function() awful.spawn("/home/charlie/.config/rofi/window.sh") end),
    -- HACK: Seems to be a bug in flameshot.
    awful.key({ modkey, "Shift" }, "s",
        function() awful.spawn("bash -c 'flameshot gui -r | xclip -selection clipboard -t image/png'") end),
    awful.key({ modkey, }, "m", function() awful.spawn("/home/charlie/.config/polybar/scripts/dunst.sh") end),
    awful.key({ modkey, }, "n", function() awful.spawn("dunstctl close-all") end),
    awful.key({ modkey, }, "-", function() awful.spawn("/home/charlie/.config/MangoHud/modify_fps_cap.sh -10") end),
    awful.key({ modkey, }, "=", function() awful.spawn("/home/charlie/.config/MangoHud/modify_fps_cap.sh 10") end),
    awful.key({ modkey, }, "Escape", function() awful.spawn("betterlockscreen --lock") end),

    -- Audio
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pamixer -i 5") end),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pamixer -d 5") end),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pamixer -t") end),

    -- Windows.
    awful.key({ modkey, }, "]", function() awful.layout.inc(1) end),
    awful.key({ modkey, }, "j", function() awful.client.focus.byidx(1) end),
    awful.key({ modkey, }, "k", function() awful.client.focus.byidx(-1) end),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),

    -- Other.
    awful.key({ modkey, "Control" }, "r", awesome.restart)
)

for i = 1, 10 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end)
    )
end

root.keys(globalkeys)

local clientkeys = gears.table.join(
    awful.key({ modkey }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end),

    awful.key({ modkey }, "q", function(c) c:kill() end),
    awful.key({ modkey }, "space", function(c)
        awful.client.floating.toggle()
        if c.floating then
            c.width = 1200
            c.height = 805
            awful.placement.centered()
        end
    end),

    awful.key({ modkey }, "o", function(c)
        c.view_mode = (c.view_mode or false)
        if not c.floating or c.fullscreen or not c.ontop then
            c.view_mode = false
        end

        if not c.view_mode then
            c.view_mode = true
            c.ontop = true
            c.floating = true

            c.width = 556
            c.height = 312
            awful.placement.bottom_right(c, {
                honor_workarea = true,
                margins = { right = 16, bottom = 34 }
            })
        else
            c.view_mode = false
            c.ontop = false
            c.floating = false
        end
    end)
)

-- -----------------------------------------------------------------------------
-- Client stuff.

local clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

awful.rules.rules = {
    {
        rule = {},
        properties = {
            border_width         = beautiful.border_width,
            border_color         = beautiful.border_normal,
            focus                = awful.client.focus.filter,
            raise                = true,
            buttons              = clientbuttons,
            keys                 = clientkeys,
            screen               = awful.screen.preferred,
            placement            = awful.placement.no_overlap + awful.placement.no_offscreen,
            floating             = false,
            maximized_vertical   = false,
            maximized_horizontal = false,
            maximized            = false,
            sticky               = false,
            fullscreen           = false,
            size_hint_honor      = true,
        }
    },
    {
        rule = { class = "Chromium-browser" },
        properties = {
            floating = false,
            maximized = false,
            maximized_vertical = false,
            maximized_horizontal = false,
        }
    },

    {
        rule_any = {
            type = {},
            class = { "Gcr-prompter" },
            role = { "Popup" },
        },
        properties = { floating = true },
        callback = awful.placement.centered
    },
}

client.connect_signal("manage", function(c)
    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        awful.placement.no_offscreen(c)
    end

    if c.floating and context == "new" then
        c.placement = awful.placement.centered + awful.placement.no_overlap
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

client.connect_signal("property::fullscreen", function(c)
    if c.fullscreen then
        awful.spawn("polybar-msg cmd hide")
    else
        awful.spawn("polybar-msg cmd show")
    end
end)


-- -----------------------------------------------------------------------------
-- Set _NET_DESKTOP_VIEWPORT so polybar pin-workspaces works per monitor.
local function update_net_desktop_viewport()
    local values = {}
    for s in screen do
        local geo = s.geometry
        for _ in ipairs(s.tags) do
            table.insert(values, tostring(geo.x))
            table.insert(values, tostring(geo.y))
        end
    end
    if #values > 0 then
        awful.spawn.with_shell(
            "xprop -root -f _NET_DESKTOP_VIEWPORT 32c -set _NET_DESKTOP_VIEWPORT '" ..
            table.concat(values, ", ") .. "'"
        )
    end
end

update_net_desktop_viewport()
screen.connect_signal("list", update_net_desktop_viewport)

-- -----------------------------------------------------------------------------
awful.spawn("/home/charlie/.scripts/startup.sh")