## Themes
# zinit light spaceship-prompt/spaceship-prompt

# SPACESHIP_PROMPT_ASYNC=false
# SPACESHIP_TIME_SHOW=true
# SPACESHIP_USER_SHOW=false

# Starship
if command -v starship >/dev/null 2>&1; then
   export STARSHIP_CONFIG=~/Documents/GitHub/faelayis/dotfiles/starship/starship.toml
   eval "$(starship init zsh)"
fi

## Plugin
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light marlonrichert/zsh-autocomplete
zinit light MichaelAquilina/zsh-you-should-use
# zinit light ntnyq/omz-plugin-bun
# zinit light ntnyq/omz-plugin-pnpm

NVM_AUTO_USE=true
zinit light lukechilds/zsh-nvm

## Snippets
zinit ice wait lucid
zinit snippet OMZL::git.zsh

zinit ice wait lucid
zinit snippet OMZP::git

zinit ice wait lucid
zinit snippet OMZP::history

zinit ice wait lucid
zinit snippet OMZP::copyfile

zinit ice wait lucid
zinit snippet OMZP::command-not-found

zinit ice wait lucid
zinit snippet OMZP::brew

zinit ice wait lucid
zinit snippet OMZP::asdf

zinit ice wait lucid
zinit snippet OMZP::flutter

zinit ice wait lucid as:completion
zinit snippet OMZP::bun

zinit ice wait lucid as:completion
zinit snippet OMZP::node

## Config
# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qNmh+24) ]]; then
  compinit
else
  compinit -C
fi