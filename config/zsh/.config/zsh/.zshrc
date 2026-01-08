export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="arch"

plugins=(
    git
    sudo
    colored-man-pages
    zsh-autosuggestions
    zsh-syntax-highlighting
    zsh-history-substring-search
    )

source $ZSH/oh-my-zsh.sh

source /usr/share/fzf/key-bindings.zsh
source /usr/share/fzf/completion.zsh

eval "$(zoxide init zsh)"

export ZCOMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$HOST-$ZSH_VERSION"
