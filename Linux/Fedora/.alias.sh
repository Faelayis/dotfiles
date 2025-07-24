# Oh My Posh Configuration
# OhMyPosh_Themes='/home/faelayis/.cache/oh-my-posh/themes/emodipt-extend.omp.json'
# eval "$(oh-my-posh init bash --config $([ $EUID != 0 ] && echo "$OhMyPosh_Themes" || echo "$OhMyPosh_Themes"))"

# Initialize
alias clear='clear && zsh'
alias reload='omz reload'

# Packages (NodeJS)
alias pn='pnpm'

# Packages
alias update-zsh='echo "RUN UPDATE (Oh My Zsh & zinit)" && omz update && zinit update --parallel && zinit delete --clean'
# alias update-ohmyposh='echo "RUN UPDATE (Oh My Posh)" && oh-my-posh upgrade'
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
