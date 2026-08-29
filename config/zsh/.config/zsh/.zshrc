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

# Add local scripts directory to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add Rust toolchain to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Load aliases from external file
source "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"
