# Oh My Posh
OhMyPosh_Themes='Documents/GitHub/JanDeDobbeleer/oh-my-posh/themes/emodipt-extend.omp.json'
eval "$(oh-my-posh init bash --config $([ $EUID != 0 ] && echo "~/$OhMyPosh_Themes" || echo "$OhMyPosh_Themes"))"

# Alias
alias sudo='sudo -E'
alias sudo='sudo '
alias reload='exec bash --login'
alias clear='printf "\033c" && reload'

# utility
alias nf='neofetch'

# packages
alias pn='pnpm'
alias update-flatpak='echo RUN UPDATE "(flatpak)" && sudo flatpak update -y'
alias update-dnf='echo RUN UPDATE "(dnf)" && sudo dnf clean all && sudo dnf check-update -y && sudo dnf upgrade -y'
alias update-all='update-dnf; update-ohmyposh; update-flatpak;'
alias update-ohmyposh='curl -s https://ohmyposh.dev/install.sh | sudo bash -s'

# DNS
alias dns='sudo gedit /etc/systemd/resolved.conf'

# ADB
alias adb-reload='sudo adb kill-server && sudo adb start-server && adb devices'

# gnome
alias gedit="gnome-text-editor"

