-------------------
---- ENV VARS -----
-------------------

-- ARCHITECTURE NOTE:
-- These variables are currently commented out because the system is managed by UWSM.
-- UWSM requires environment variables to be set in `~/.config/uwsm/env` instead.
-- This file serves as a fallback ONLY if UWSM is removed in the future.

-- Toolkit Backends
-- hl.env("GDK_BACKEND", "wayland,x11,*")
-- hl.env("QT_QPA_PLATFORM", "wayland;xcb")
-- hl.env("SDL_VIDEODRIVER", "wayland")
-- hl.env("CLUTTER_BACKEND", "wayland")

-- Qt Configuration
-- hl.env("QT_WAYLAND_DISABLE_WINDOWDECORATION", "1")
-- hl.env("QT_QPA_PLATFORMTHEME", "qt5ct")
-- hl.env("QT_AUTO_SCREEN_SCALE_FACTOR", "1") -- Uncomment only for HiDPI

-- Themes and Cursors
-- hl.env("XCURSOR_THEME", "Bibata-Modern-Classic")
-- hl.env("XCURSOR_SIZE", "24")

-- XDG Specifications
-- If not using UWSM, these must be set manually to fix xdg-desktop-portal issues.
-- hl.env("XDG_CURRENT_DESKTOP", "Hyprland")
-- hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("XDG_SESSION_DESKTOP", "Hyprland")
