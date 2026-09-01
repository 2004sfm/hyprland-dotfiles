#!/bin/bash
# Cursor
hyprctl setcursor Bibata-Modern-Ice 24
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Ice'
gsettings set org.gnome.desktop.interface cursor-size 24

# GTK Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-light'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-light'
