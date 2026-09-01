#!/bin/bash

# install.sh — Bootstrap dotfiles + Theme Hub symlinks
# Run once after cloning on a new machine

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles directory: $DOTFILES_DIR"
echo ""

# ─── Install Chaotic AUR ─────────────────────────────────────────────────────────

if ! grep -qF "[chaotic-aur]" /etc/pacman.conf; then
    echo "==> Setting up Chaotic AUR..."
    sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    sudo pacman-key --lsign-key 3056513887B78AEB

    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst'
    sudo pacman -U --noconfirm 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'

    echo -e "\n[chaotic-aur]\nInclude = /etc/pacman.d/chaotic-mirrorlist" | sudo tee -a /etc/pacman.conf

    # Sync repositories
    sudo pacman -Syu --noconfirm
else
    echo "==> Chaotic AUR is already configured."
fi
echo ""

# ─── Install yay ───────────────────────────────────────────────────────────────

if ! command -v yay &> /dev/null; then
    echo "==> Installing yay from Chaotic AUR..."
    # Since Chaotic AUR is enabled, yay is available via pacman
    sudo pacman -S --needed --noconfirm base-devel git yay
else
    echo "==> yay is already installed."
fi
echo ""

# ─── Install dependencies ──────────────────────────────────────────────────────

echo "==> Installing required packages..."
yay -S --needed --noconfirm \
    stow \
    kitty \
    waybar \
    swaync \
    hyprpaper \
    hypridle \
    hyprshot \
    polkit-gnome \
    wl-clip-persist \
    brightnessctl \
    playerctl \
    wireplumber \
    bibata-cursor-theme \
    materia-gtk-theme \
    nautilus \
    zoxide \
    fnm \
    rustup \
    zsh-antidote

echo "==> Configuring Rust toolchain (rustup default stable)..."
rustup default stable

echo ""

# ─── Helper ───────────────────────────────────────────────────────────────────

stow_pkg() {
    local base="$1"   # directory containing the stow package
    local target="$2" # where to link (usually $HOME)
    local pkg="$3"    # package name (subfolder inside base)
    echo "    stow: $pkg -> $target"
    stow -d "$base" -t "$target" "$pkg"
}

# ─── Stow packages ────────────────────────────────────────────────────────────

echo "==> Deploying dotfiles with stow..."

# Backup ~/.config/hypr if it's a real directory (not a symlink from a previous stow)
if [ -d "$HOME/.config/hypr" ] && [ ! -L "$HOME/.config/hypr" ]; then
    echo "    ~/.config/hypr exists as a real directory — renaming to hypr.bak"
    mv "$HOME/.config/hypr" "$HOME/.config/hypr.bak"
fi

# Config packages (all live inside config/)
for pkg in hypr-lua kitty waybar swaync uwsm zsh theme; do
    stow_pkg "$DOTFILES_DIR/config" "$HOME" "$pkg"
done

# Scripts (.local/bin structure → maps to ~)
stow_pkg "$DOTFILES_DIR" "$HOME" scripts

# Wallpapers (files live directly in pictures/ → maps to ~/Pictures/Wallpapers)
mkdir -p "$HOME/Pictures/Wallpapers"
stow_pkg "$DOTFILES_DIR" "$HOME/Pictures/Wallpapers" pictures

echo ""

# ─── Theme Hub symlinks ────────────────────────────────────────────────────────

echo "==> Setting up Theme Hub symlinks (default: dark)..."

ln -sf ~/.config/theme/css/dark.css       ~/.config/theme/css/current.css
echo "    css/current.css -> dark.css"

ln -sf ~/.config/theme/kitty/dark.conf    ~/.config/theme/kitty/current.conf
echo "    kitty/current.conf -> dark.conf"

ln -sf ~/.config/theme/hypr/dark.lua      ~/.config/theme/hypr/current.lua
echo "    hypr/current.lua -> dark.lua"

mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

ln -sf ~/.config/theme/gtk3/dark.ini      ~/.config/gtk-3.0/settings.ini
echo "    gtk-3.0/settings.ini -> theme/gtk3/dark.ini"

ln -sf ~/.config/theme/gtk4/dark.ini      ~/.config/gtk-4.0/settings.ini
echo "    gtk-4.0/settings.ini -> theme/gtk4/dark.ini"

ln -sf ~/hyprland-dotfiles/pictures/wallpaper-1920x1080.png ~/Pictures/Wallpapers/current-wallpaper.png
echo "    current-wallpaper.png -> ~/hyprland-dotfiles/pictures/wallpaper-1920x1080.png"

ln -sf ~/.config/theme/cursor/dark.sh     ~/.config/theme/cursor/current.sh
echo "    cursor/current.sh -> dark.sh"

echo ""
echo "Done! Default theme: dark."
echo "Run toggle-theme to switch themes."
