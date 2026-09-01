---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER" -- Sets "Windows" key as main modifier

-- Define desktop applications with the proper execution prefix
local terminal    = EXEC_PREFIX .. "kitty"
local fileManager = EXEC_PREFIX .. "nautilus"
local menu        = EXEC_PREFIX .. "hyprlauncher" -- or use wofi launcher with ".local/bin/wofi-launcher"
local browser     = EXEC_PREFIX .. "zen-browser"
local editor      = EXEC_PREFIX .. "zeditor"
local zapzap      = EXEC_PREFIX .. "zapzap"
local vesktop     = EXEC_PREFIX .. "vesktop"

-- Example binds, see https://wiki.hypr.land/Configuring/Basics/Binds/ for more
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(browser .. " --private-window"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(editor))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd(zapzap))
hl.bind(mainMod .. " + SHIFT + D", hl.dsp.exec_cmd(vesktop))

hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("~/.local/bin/toggle-theme"))

-- Hyprshot (Clipboard Only)
hl.bind("PRINT", hl.dsp.exec_cmd(EXEC_PREFIX .. "hyprshot -m output -m active --clipboard-only"))               -- Screenshot a monitor
hl.bind(mainMod .. " + PRINT", hl.dsp.exec_cmd(EXEC_PREFIX .. "hyprshot -m window -m active --clipboard-only")) -- Screenshot a window
hl.bind(mainMod .. " + SHIFT + PRINT", hl.dsp.exec_cmd(EXEC_PREFIX .. "hyprshot -m region --clipboard-only"))   -- Screenshot a region


local closeWindowBind = hl.bind(mainMod .. " + Q", hl.dsp.window.close())
-- closeWindowBind:set_enabled(false)

-- Fullscreen and Maximize
hl.bind(mainMod .. " + F",         hl.dsp.window.fullscreen_state({ internal = 1, client = 1, action = "toggle" })) -- Maximize
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.fullscreen_state({ internal = 2, client = 2, action = "toggle" })) -- Fullscreen

hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" })) -- float window
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + TAB", hl.dsp.layout("togglesplit"))    -- dwindle only

-- Move focus with mainMod + arrow keys
hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

-- Switch workspaces with mainMod + [0-9]
-- Move active window to a workspace with mainMod + SHIFT + [0-9]
for i = 1, 10 do
    local key = i % 10 -- 10 maps to key 0
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i }))
end

-- Example special workspace (scratchpad)
hl.bind(mainMod .. " + S",         hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.window.move({ workspace = "special:magic" }))

-- Scroll through existing workspaces with mainMod + scroll
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse_up",   hl.dsp.focus({ workspace = "e-1" }))

-- Move/resize windows with mainMod + LMB/RMB and dragging
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Laptop multimedia keys for volume and LCD brightness
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"),                  { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"),                  { locked = true, repeating = true })

-- Requires playerctl
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

-- hyprlock
hl.bind("switch:on:Lid Switch", hl.dsp.exec_cmd("systemctl suspend"), { locked = true })
