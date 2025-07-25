## Plugin
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light marlonrichert/zsh-autocomplete
zinit light zsh-users/zsh-completions
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
zinit light ntnyq/omz-plugin-bun
zinit light MichaelAquilina/zsh-you-should-use

## Snippets
zinit snippet OMZP::bun
zinit snippet OMZP::dnf
zinit snippet OMZP::git
zinit snippet OMZL::git.zsh
zinit snippet OMZP::copyfile
zinit snippet OMZP::history
zinit snippet OMZL::async_prompt.zsh 
zinit snippet OMZP::command-not-found

## Config
# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

autoload -Uz compinit && compinit