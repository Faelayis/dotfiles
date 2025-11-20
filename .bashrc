# Starship
if command -v starship >/dev/null 2>&1; then
   export STARSHIP_CONFIG=~/Documents/GitHub/faelayis/dotfiles/starship/starship.toml
   eval "$(starship init bash)"
fi

# Import alias
source ~/Documents/GitHub/faelayis/dotfiles/alias.sh