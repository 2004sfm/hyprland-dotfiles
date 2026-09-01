-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
    -- Authentication Agent (Polkit)
    hl.exec_cmd(EXEC_PREFIX .. "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- hl.exec_cmd(EXEC_PREFIX .. "hyprpolkitagent")                                                   -- Hyprland native alternative

    -- UI Components
    hl.exec_cmd(os.getenv("HOME") .. "/.config/theme/cursor/current.sh")                              -- Set cursor theme and size (managed by Theme Hub)

    hl.exec_cmd(EXEC_PREFIX .. "waybar")                                                               -- Status bar
    hl.exec_cmd(EXEC_PREFIX .. "hyprpaper")                                                            -- Wallpaper daemon
    hl.exec_cmd(EXEC_PREFIX .. "swaync")                                                               -- Notification daemon
    hl.exec_cmd(EXEC_PREFIX .. "hyprlauncher -d")                                                      -- App launcher

    -- System Services & Clipboard
    hl.exec_cmd(EXEC_PREFIX .. "wl-clip-persist --clipboard regular")                                  -- Clipboard history

    -- Idle & Power Management
    -- Manages screen dimming, locking, and system suspension based on inactivity
    hl.exec_cmd(EXEC_PREFIX .. "hypridle")
end)
