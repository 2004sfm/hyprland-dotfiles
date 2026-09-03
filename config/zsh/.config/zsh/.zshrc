# Enable the native Zsh completion system
autoload -Uz compinit
compinit -C

# Show custom icon
# cat ~/icons/icon-terminal.txt
# chafa --size=20 ~/icons/icon.svg

# Initialize Homebrew environment variables
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# Add local scripts directory to PATH
export PATH="$HOME/.local/bin:$PATH"

# Add Rust toolchain to PATH
export PATH="$HOME/.cargo/bin:$PATH"

# Add pnpm package manager to PATH
export PNPM_HOME="$HOME/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# Integrate fnm to manage Node.js versions
eval "$(fnm env --use-on-cd --shell zsh)"

# Set up Zoxide for smart directory navigation
eval "$(zoxide init zsh)"

# Source Antidote (plugin manager), installed via AUR (yay)
source /usr/share/zsh-antidote/antidote.zsh

# Deploy the plugins listed in the configuration file (".zsh_plugins.txt")
antidote load "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"

# Load aliases from external file
source "${ZDOTDIR:-$HOME/.config/zsh}/aliases.zsh"
