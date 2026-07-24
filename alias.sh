# Initialize
alias clear='clear && exec zsh'
reload() {
   source "$ZSH/oh-my-zsh.sh" || return 1
   omz reload
}

# Packages (NodeJS)
alias pn='pnpm'

# Packages
# https://github.com/topgrade-rs/topgrade
alias update-all='topgrade'

# Utility
alias nf='fastfetch'
alias ff='fastfetch'

# DNS
alias dns='sudo gedit /etc/systemd/resolved.conf'

# ADB
alias adb-reload='sudo adb kill-server && sudo adb start-server && adb devices'

# GNOME
alias gedit="gnome-text-editor"
