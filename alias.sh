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
