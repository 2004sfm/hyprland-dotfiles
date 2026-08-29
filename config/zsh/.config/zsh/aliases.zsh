# Clean up orphaned packages and their dependencies
alias pacclean='orphans=$(pacman -Qdtq); [ -n "$orphans" ] && sudo pacman -Rns $orphans'

# Start and stop the Docker daemon
alias docker-start='sudo systemctl start docker'
alias docker-stop='sudo systemctl stop docker docker.socket'

# Update mirror servers using reflector
alias update-mirrors='sudo reflector --latest 50 --number 20 --sort rate --save /etc/pacman.d/mirrorlist'
