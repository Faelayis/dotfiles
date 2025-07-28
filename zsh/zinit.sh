## Plugin
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light marlonrichert/zsh-autocomplete
zinit light MichaelAquilina/zsh-you-should-use
zinit light ntnyq/omz-plugin-bun
zinit light ntnyq/omz-plugin-pnpm

## Snippets
# OMZ/lib/
zinit snippet OMZL::git.zsh
zinit snippet OMZL::async_prompt.zsh 
zinit snippet OMZL::prompt_info_functions.zsh

# OMZ/plugins/
zinit snippet OMZP::nvm
zinit snippet OMZP::node
zinit snippet OMZP::nodenv
zinit snippet OMZP::bun
zinit snippet OMZP::dnf
zinit snippet OMZP::git
zinit snippet OMZP::history
zinit snippet OMZP::copyfile
zinit snippet OMZP::command-not-found

## Config
# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

autoload -Uz compinit && compinit