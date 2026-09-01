#!/bin/bash
# Cursor
hyprctl setcursor Bibata-Modern-Classic 24
gsettings set org.gnome.desktop.interface cursor-theme 'Bibata-Modern-Classic'
gsettings set org.gnome.desktop.interface cursor-size 24

# GTK Theme
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
