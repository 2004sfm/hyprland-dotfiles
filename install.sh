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

echo "==> Resolving modules..."

# Apps (GUI & CLI tools)
APPS=(
    "kitty"
    "nautilus"
    "blueman"
)

# Dotfiles core (Daemons, plugins, themes, system integration)
DOTFILES_CORE=(
    "stow"
    "waybar"
    "swaync"
    "hyprpaper"
    "hypridle"
    "hyprshot"
    "hyprland-preview-share-picker-git"
    "polkit-gnome"
    "wl-clip-persist"
    "brightnessctl"
    "playerctl"
    "wireplumber"
    "bluez"
    "bluez-utils"
    "zoxide"
    "zsh-antidote"
    "bibata-cursor-theme"
    "materia-gtk-theme"
)

# Version Managers
MANAGERS=(
    "fnm"
    "uv"
    "rustup"
)

# Fonts
FONTS=(
    "ttf-jetbrains-mono-nerd"
    "apple-fonts"
)

echo "==> Installing Dotfiles Core..."
yay -S --needed --noconfirm "${DOTFILES_CORE[@]}"

echo "==> Installing Version Managers..."
yay -S --needed --noconfirm "${MANAGERS[@]}"

echo "==> Installing Fonts..."
yay -S --needed --noconfirm "${FONTS[@]}"

echo "==> Installing Apps..."
yay -S --needed --noconfirm "${APPS[@]}"

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
for pkg in hypr kitty waybar swaync uwsm zsh theme wofi wlogout hyprland-preview-share-picker; do
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
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

~/.local/bin/set-theme dark

echo ""
echo "Done! Default theme: dark."
echo "Run toggle-theme to switch themes."
