## Shell behavior
export ZSH_CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d "$ZSH_CACHE_DIR/completions" ]] || command mkdir -p "$ZSH_CACHE_DIR/completions"

typeset -U fpath
fpath=("$ZSH_CACHE_DIR/completions" $fpath)

zinit snippet OMZL::history.zsh
zinit snippet OMZL::key-bindings.zsh

autoload -Uz add-zsh-hook
typeset -g _history_autosuggest_ignore_base=${ZSH_AUTOSUGGEST_HISTORY_IGNORE-}

_history_ignore_unknown_commands() {
  emulate -L zsh
  setopt extended_glob

  local line=${1%%$'\n'}
  local -a words
  words=(${(z)line})
  local command_name=${words[1]}

  ZSH_AUTOSUGGEST_HISTORY_IGNORE=$_history_autosuggest_ignore_base

  [[ -z $command_name || $command_name != [[:alnum:]_.-]## ]] && return 0
  whence -w -- "$command_name" >/dev/null 2>&1 && return 0

  if [[ -n $_history_autosuggest_ignore_base ]]; then
    ZSH_AUTOSUGGEST_HISTORY_IGNORE="($_history_autosuggest_ignore_base|${(b)line})"
  else
    ZSH_AUTOSUGGEST_HISTORY_IGNORE=${(b)line}
  fi

  return 1
}

add-zsh-hook zshaddhistory _history_ignore_unknown_commands

## Completion and widgets
zinit light zsh-users/zsh-completions
zinit ice cloneonly cloneopts"--no-recurse-submodules" \
  atclone"git config submodule.z-async.url https://github.com/marlonrichert/z-async.git && git submodule update --init z-async" \
  atpull"%atclone"
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

_nvm_lazy_auto_use() {
  if (( ! $+functions[nvm_find_nvmrc] )); then
    local nvmrc_dir="$PWD"
    while [[ "$nvmrc_dir" != / && ! -f "$nvmrc_dir/.nvmrc" ]]; do
      nvmrc_dir="${nvmrc_dir:h}"
    done

    [[ -f "$nvmrc_dir/.nvmrc" ]] || return
    nvm --version >/dev/null
  fi

  _zsh_nvm_auto_use >/dev/null
}

_nvm_lazy_auto_use_init() {
  autoload -U add-zsh-hook
  add-zsh-hook chpwd _nvm_lazy_auto_use
  _nvm_lazy_auto_use
}

zinit light lukechilds/zsh-nvm
_nvm_lazy_auto_use_init

## Interactive widgets
zinit ice cloneonly depth"1"
zinit light Michael-Matta1/zsh-edit-select
source "$ZINIT[PLUGINS_DIR]/Michael-Matta1---zsh-edit-select/zsh-edit-select.plugin.zsh"

bindkey -M emacs $'\e[99;6u' edit-select::copy-region
bindkey -M edit-select $'\e[99;6u' edit-select::copy-region

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
