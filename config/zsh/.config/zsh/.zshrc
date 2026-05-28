# Enable the native Zsh completion system
autoload -Uz compinit
compinit

# Source Antidote (plugin manager), installed via AUR (yay)
source /usr/share/zsh-antidote/antidote.zsh

# Deploy the plugins listed in the configuration file (".zsh_plugins.txt")
antidote load "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"

# Set up Zoxide for smart directory navigation
eval "$(zoxide init zsh)"

# Integrate fnm to manage Node.js versions
eval "$(fnm env --use-on-cd --shell zsh)"
