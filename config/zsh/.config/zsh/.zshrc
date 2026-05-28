autoload -Uz compinit
compinit

# source antidote, instlled with yay
source /usr/share/zsh-antidote/antidote.zsh

# initialize plugins statically with ${ZDOTDIR:-$HOME}/.zsh_plugins.txt
antidote load "${ZDOTDIR:-$HOME/.config/zsh}/.zsh_plugins.txt"

# export ZSH="$HOME/.oh-my-zsh"

# ZSH_THEME="arch"

# plugins=(
#     git
#     sudo
#     colored-man-pages
#     zsh-autosuggestions
#     zsh-syntax-highlighting
#     zsh-history-substring-search
#    )

# source $ZSH/oh-my-zsh.sh

# source /usr/share/fzf/key-bindings.zsh
# source /usr/share/fzf/completion.zsh

# eval "$(zoxide init zsh)"

# eval "$(fnm env --use-on-cd --shell zsh)"
