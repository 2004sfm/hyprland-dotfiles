# Enable the native Zsh completion system
autoload -Uz compinit
compinit -C

# Show custom icon
# cat ~/icons/icon-terminal.txt
# chafa --size=20 ~/icons/icon.svg

# Initialize Homebrew environment variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Set up Zoxide for smart directory navigation
eval "$(zoxide init zsh)"

# Integrate fnm to manage Node.js versions
eval "$(fnm env --use-on-cd --shell zsh)"

# Source Antidote (plugin manager), installed via AUR (yay)
source /usr/share/zsh-antidote/antidote.zsh

# Deploy the plugins listed in the configuration file (".zsh_plugins.txt")
antidote load "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"

export PATH="$HOME/.cargo/bin:$PATH"

# Clean up orphaned packages and their dependencies
alias pacclean='orphans=$(pacman -Qdtq); [ -n "$orphans" ] && sudo pacman -Rns $orphans'

# Start and stop the Docker daemon
alias docker-start='sudo systemctl start docker'
alias docker-stop='sudo systemctl stop docker docker.socket'

# Update mirror servers using reflector
alias update-mirrors='sudo reflector --latest 50 --number 20 --sort rate --save /etc/pacman.d/mirrorlist'
