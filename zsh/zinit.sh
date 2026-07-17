## Themes
# zinit light spaceship-prompt/spaceship-prompt

## Plugin
# zinit light zsh-users/zsh-autosuggestions
# zinit light Aloxaf/fzf-tab
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light marlonrichert/zsh-autocomplete
zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use
# zinit light ntnyq/omz-plugin-bun
# zinit light ntnyq/omz-plugin-pnpm

# Keep the default Node executable available while loading nvm on demand.
export NVM_DIR="$HOME/.nvm"
typeset _nvm_default _nvm_alias_hop
if [[ -r "$NVM_DIR/alias/default" ]]; then
  _nvm_default="$(<"$NVM_DIR/alias/default")"
  for _nvm_alias_hop in {1..5}; do
    [[ -r "$NVM_DIR/alias/$_nvm_default" ]] || break
    _nvm_default="$(<"$NVM_DIR/alias/$_nvm_default")"
  done

  if [[ -d "$NVM_DIR/versions/node/$_nvm_default/bin" ]]; then
    export NVM_BIN="$NVM_DIR/versions/node/$_nvm_default/bin"
    export NVM_INC="$NVM_DIR/versions/node/$_nvm_default/include/node"
    typeset -U path
    path=(${path:#$NVM_DIR/versions/node/*/bin})
    path=("$NVM_BIN" $path)
  fi
fi
unset _nvm_default _nvm_alias_hop

export NVM_LAZY_LOAD=true
export NVM_NO_USE=true
export NVM_COMPLETION=true
export NVM_AUTO_USE=false
zinit light lukechilds/zsh-nvm

## Snippets
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
zinit snippet OMZP::node

## Config
# zsh-users/zsh-autosuggestions
ZSH_AUTOSUGGEST_USE_ASYNC=true
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'

autoload -Uz compinit zrecompile
typeset _zcompdump="${ZDOTDIR:-$HOME}/.zcompdump"
typeset -a _zcompdump_stale
_zcompdump_stale=("$_zcompdump"(N.mh+24))

if [[ ! -s "$_zcompdump" || ${#_zcompdump_stale} -ne 0 ]]; then
  compinit -d "$_zcompdump"
  [[ -s "$_zcompdump" ]] && command touch "$_zcompdump"
else
  compinit -C -d "$_zcompdump"
fi

# Compile the dump once so warm shells avoid parsing the text cache.
if [[ -s "$_zcompdump" && (! -s "$_zcompdump.zwc" || "$_zcompdump" -nt "$_zcompdump.zwc") ]]; then
  if command mkdir "$_zcompdump.lock" 2>/dev/null; then
    zrecompile -q -p "$_zcompdump"
    command rm -f "$_zcompdump.zwc.old"
    command rmdir "$_zcompdump.lock" 2>/dev/null
  fi
fi

unset _zcompdump _zcompdump_stale

# Let zsh-autocomplete reuse the initialized cache instead of rebuilding it at precmd.
compdef _autocomplete__command -command-
