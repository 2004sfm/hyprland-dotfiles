#!/bin/bash

# install.sh — Bootstrap dotfiles + Theme Hub symlinks
# Run once after cloning on a new machine

set -e

if [ "$EUID" -eq 0 ]; then
    echo "Error: Please run this script as a normal user (without sudo)."
    echo "The script will prompt for sudo when necessary."
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> Dotfiles directory: $DOTFILES_DIR"
echo ""

read -r -p "==> Do you want to update Pacman mirrors using reflector? (Y/n) " update_mirrors
if [[ -z "$update_mirrors" || "$update_mirrors" =~ ^[Yy]$ ]]; then
    echo "==> Installing reflector and updating mirrors..."
    sudo pacman -S --needed --noconfirm reflector
    sudo reflector --protocol https --latest 20 --number 10 --sort rate --save /etc/pacman.d/mirrorlist || echo "==> Warning: Reflector failed, proceeding with current mirrorlist."
    echo "==> Mirrors updated successfully."
else
    echo "==> Skipping mirror update."
fi
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

# Ensure build tools are present for AUR compilation
echo "==> Ensuring base-devel and git are installed..."
sudo pacman -S --needed --noconfirm base-devel git

if ! command -v yay &> /dev/null; then
    echo "==> Installing yay from Chaotic AUR..."
    # Since Chaotic AUR is enabled, yay is available via pacman
    sudo pacman -S --needed --noconfirm yay
else
    echo "==> yay is already installed."
fi
echo ""

# ─── Install Homebrew ─────────────────────────────────────────────────────────

if ! command -v brew &> /dev/null && [ ! -d "/home/linuxbrew/.linuxbrew" ]; then
    echo "==> Installing Homebrew for Linux..."
    sudo pacman -S --needed --noconfirm procps-ng curl file git
    NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || echo "==> Warning: Homebrew installation was interrupted or failed."
    if [ -f /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
else
    echo "==> Homebrew is already installed."
fi
echo ""

# ─── Install dependencies ──────────────────────────────────────────────────────

echo "==> Resolving modules..."

# Apps (GUI & CLI tools)
APPS=(
    "kitty"
    "nautilus"
    "blueman"
    "firefox"
    "neovim"
    "zen-browser-bin"
    "wofi"
    "htop"
    "tree"
    "github-cli"
)

# Dotfiles core (Daemons, plugins, themes, system integration)
DOTFILES_CORE=(
    "hyprland"
    "uwsm"
    "xdg-desktop-portal-hyprland"
    "xdg-user-dirs"
    "qt5-wayland"
    "qt6-wayland"
    "stow"
    "waybar"
    "swaync"
    "hyprpaper"
    "hypridle"
    "hyprlauncher"
    "hyprshot"
    "grim"
    "slurp"
    "wl-clipboard"
    "jq"
    "hyprland-preview-share-picker-git"
    "polkit-gnome"
    "wl-clip-persist"
    "brightnessctl"
    "playerctl"
    "wireplumber"
    "bluez"
    "bluez-utils"
    "zoxide"
    "zsh"
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

# Handle rust / rustup conflict:
# 'rustup' conflicts with Arch's repo 'rust', 'cargo', and 'rustfmt'.
# When --noconfirm is used, pacman defaults to [N] (don't remove), causing failure.
# Also, installing rustup before AUR packages ensures 'cargo' make-dependencies
# are satisfied by rustup rather than pulling in repo 'rust'.
for pkg in rust cargo rustfmt; do
    if pacman -Qq 2>/dev/null | grep -Fxq "$pkg"; then
        echo "==> Removing conflicting '$pkg' package before installing rustup..."
        sudo pacman -Rdd --noconfirm "$pkg"
    fi
done

echo "==> Installing Version Managers..."
yay -S --needed --noconfirm "${MANAGERS[@]}"

echo "==> Configuring Rust toolchain (rustup default stable)..."
rustup default stable

echo "==> Installing Dotfiles Core..."
yay -S --needed --noconfirm "${DOTFILES_CORE[@]}"

echo "==> Installing Fonts..."
yay -S --needed --noconfirm "${FONTS[@]}"

echo "==> Installing Apps..."
yay -S --needed --noconfirm "${APPS[@]}"

echo "==> Generating standard user directories (Downloads, Pictures, etc.)..."
xdg-user-dirs-update

echo "==> Setting ZSH as the default shell..."
ZSH_PATH="$(command -v zsh || true)"
if [ -n "$ZSH_PATH" ] && [ "$SHELL" != "$ZSH_PATH" ]; then
    sudo chsh -s "$ZSH_PATH" "$USER" || chsh -s "$ZSH_PATH" || echo "==> Note: Could not change default shell automatically. You can run 'chsh -s $ZSH_PATH' manually."
fi

echo "==> Configuring Git global settings (linking dotfiles gitconfig)..."
git config --global include.path "$DOTFILES_DIR/gitconfig"

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

echo "==> Configuring systemd logind for Hypridle..."
if ! grep -q "^HandleLidSwitch=ignore" /etc/systemd/logind.conf; then
    echo "    Delegating lid switch handling to Hypridle..."
    sudo sed -i 's/^#*HandleLidSwitch=.*/HandleLidSwitch=ignore/' /etc/systemd/logind.conf
    sudo systemctl restart systemd-logind || true
fi

echo "==> Enabling system services (Bluetooth)..."
sudo systemctl enable bluetooth.service || true

# Backup ~/.zshenv if it's a real file (not a symlink from a previous stow)
if [ -f "$HOME/.zshenv" ] && [ ! -L "$HOME/.zshenv" ]; then
    echo "    ~/.zshenv exists as a real file — renaming to .zshenv.bak"
    mv "$HOME/.zshenv" "$HOME/.zshenv.bak"
fi

# Config packages (all live inside config/)
# Backs up any real directory to prevent stow conflicts
for pkg in hypr kitty waybar swaync uwsm zsh theme wofi wlogout hyprland-preview-share-picker; do
    if [ -d "$HOME/.config/$pkg" ] && [ ! -L "$HOME/.config/$pkg" ]; then
        echo "    ~/.config/$pkg exists as a real directory — renaming to ${pkg}.bak"
        mv "$HOME/.config/$pkg" "$HOME/.config/${pkg}.bak"
    fi
    stow_pkg "$DOTFILES_DIR/config" "$HOME" "$pkg"
done

# Scripts (.local structure → maps to ~)
# Ensure ~/.local is a real directory and never a symlink (prevents stow tree-folding)
if [ -L "$HOME/.local" ]; then
    echo "    ~/.local is a symlink from a previous setup — removing symlink..."
    rm "$HOME/.local"
fi
mkdir -p "$HOME/.local/bin"
chmod +x "$DOTFILES_DIR"/scripts/.local/bin/*
stow_pkg "$DOTFILES_DIR" "$HOME" scripts

# Wallpapers (files live directly in pictures/ → maps to ~/Pictures/Wallpapers)
mkdir -p "$HOME/Pictures/Wallpapers"
stow_pkg "$DOTFILES_DIR" "$HOME/Pictures/Wallpapers" pictures

echo ""

echo "==> Pre-compiling ZSH plugins with Antidote..."
zsh -c 'source /usr/share/zsh-antidote/antidote.zsh && antidote bundle < "$HOME/.config/zsh/.zsh_plugins.txt" > "$HOME/.config/zsh/.zsh_plugins.zsh"' || echo "==> Note: ZSH plugins will be bundled on first shell launch."

echo ""

# ─── Theme Hub symlinks ────────────────────────────────────────────────────────

echo "==> Setting up UWSM desktop shortcuts..."
~/.local/bin/wrap-uwsm

echo "==> Setting up Theme Hub symlinks (default: dark)..."
mkdir -p ~/.config/gtk-3.0 ~/.config/gtk-4.0

~/.local/bin/set-theme dark

echo ""
echo "Done! Default theme: dark."
echo "Run toggle-theme to switch themes."
