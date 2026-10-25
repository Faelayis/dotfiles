# Starship
if command -v starship >/dev/null 2>&1; then
   export STARSHIP_CONFIG=$HOME/Documents/GitHub/faelayis/dotfiles/starship/starship.toml
   eval "$(starship init zsh)"
fi

# Import alias
source "$HOME/Documents/GitHub/faelayis/dotfiles/alias.sh"

# Import Zinit
source "$HOME/Documents/GitHub/faelayis/dotfiles/zsh/zinit.sh"