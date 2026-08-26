-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

-- Autostart necessary processes (like notifications daemons, status bars, etc.)
-- Or execute your favorite apps at launch like this:

hl.on("hyprland.start", function()
    -- Authentication Agent (Polkit)
    hl.exec_cmd("uwsm app -- /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1")
    -- hl.exec_cmd("uwsm app -- hyprpolkitagent")                                                   -- Hyprland native alternative

    -- # Window Decorations
    hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark'")
    hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")

    -- UI Components
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'")   -- Set GTK cursor theme
    hl.exec_cmd("gsettings set org.gnome.desktop.interface cursor-size 24")                         -- Set GTK cursor size
    hl.exec_cmd("hyprctl setcursor Bibata-Modern-Classic 24")                                       -- Set Hypr cursor theme

    hl.exec_cmd("uwsm app -- waybar")                                                               -- Status bar
    hl.exec_cmd("uwsm app -- hyprpaper")                                                            -- Wallpaper daemon
    hl.exec_cmd("uwsm app -- dunst")                                                                -- Notification daemon

    -- System Services & Clipboard
    hl.exec_cmd("uwsm app -- wl-clip-persist --clipboard regular")                                  -- Clipboard history

    -- Idle & Power Management
    -- Manages screen dimming, locking, and system suspension based on inactivity
    hl.exec_cmd("uwsm app -- hypridle")
end)
