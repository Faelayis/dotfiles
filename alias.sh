# Initialize
alias clear='clear && exec zsh'
alias reload='omz reload'

# Packages (NodeJS)
alias pn='pnpm'

# Packages
alias update-zsh='echo "RUN UPDATE (Oh My Zsh & zinit)" && omz update && zinit update --parallel && zinit delete --clean && zinit cclear'
alias update-flatpak='echo "RUN UPDATE (Flatpak)" && flatpak update -y'
alias update-dnf='echo "RUN UPDATE (dnf)" && sudo dnf upgrade -y'
alias update-all='echo "RUN UPDATE ALL" && update-dnf && update-zsh && update-flatpak'

# Utility
alias nf='fastfetch'
alias ff='fastfetch'

# DNS
alias dns='sudo gedit /etc/systemd/resolved.conf'

# ADB
alias adb-reload='sudo adb kill-server && sudo adb start-server && adb devices'

# GNOME
alias gedit="gnome-text-editor"
