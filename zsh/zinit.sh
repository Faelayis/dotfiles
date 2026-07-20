## Shell behavior
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR/completions" ]] || command mkdir -p "$ZSH_CACHE_DIR/completions"

typeset -U fpath
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

## Completion and widgets
zinit light zsh-users/zsh-completions
zinit ice cloneonly
zinit light marlonrichert/zsh-autocomplete
source "$ZINIT[PLUGINS_DIR]/marlonrichert---zsh-autocomplete/zsh-autocomplete.plugin.zsh"

# Generated completion scripts should not initialize completion before autocomplete.
compinit() { :; }

## Oh My Zsh dependencies
zstyle ':omz:alpha:lib:git' async-prompt no
zinit snippet OMZL::git.zsh
zinit snippet OMZL::clipboard.zsh
zinit snippet OMZL::functions.zsh

## Completion-aware snippets
zinit snippet OMZP::brew
zinit snippet OMZP::asdf
zinit snippet OMZP::flutter
zinit snippet OMZP::git

## Runtime tools
# zinit light ntnyq/omz-plugin-bun
# zinit light ntnyq/omz-plugin-pnpm
zinit ice from"gh-r" as"program"
zinit light ajeetdsouza/zoxide

eval "$(zoxide init zsh)"

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
zinit ice wait lucid
zinit light lukechilds/zsh-nvm

## Interactive widgets
zinit ice cloneonly depth"1"
zinit light Michael-Matta1/zsh-edit-select
source "$ZINIT[PLUGINS_DIR]/Michael-Matta1---zsh-edit-select/zsh-edit-select.plugin.zsh"

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=247'
zinit light zsh-users/zsh-autosuggestions

_tab_accept_autosuggestion_or_complete() {
  if (( $#POSTDISPLAY && CURSOR == $#BUFFER )); then
    zle autosuggest-accept
  else
    zle complete-word -w
  fi
}

zle -N tab-accept-autosuggestion-or-complete _tab_accept_autosuggestion_or_complete
ZSH_AUTOSUGGEST_IGNORE_WIDGETS+=(tab-accept-autosuggestion-or-complete)
bindkey -M main '^I' tab-accept-autosuggestion-or-complete

## Deferred helpers
zinit ice wait lucid
zinit light zdharma-continuum/fast-syntax-highlighting

zinit ice wait lucid
zinit light MichaelAquilina/zsh-you-should-use

zinit ice wait lucid
zinit snippet OMZP::history

zinit ice wait lucid
zinit snippet OMZP::copyfile

zinit ice wait lucid
zinit snippet OMZP::command-not-found

zinit ice wait lucid
zinit snippet OMZP::node
