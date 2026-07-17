#!/usr/bin/env bash

set -Eeuo pipefail

LINUX_STEAM_ROOT="${LINUX_STEAM_ROOT:-$HOME/.local/share/Steam}"

DRY_RUN=0
TEMP_MANIFEST=""
FOUND_MANIFEST=""

usage() {
  cat <<'EOF'
Usage: steam-library-sync.sh [--dry-run]

Discover game-directory symlinks in the Linux Steam library and synchronize
their manifests from the Steam libraries each symlink points to. If a target
volume is configured in /etc/fstab but is not mounted, request authorization
to mount it. Steam must be closed while synchronization runs.
EOF
}

log() {
  printf '[steam-library-sync] %s\n' "$*"
}

fail() {
  log "ERROR: $*" >&2
  exit 1
}

cleanup() {
  [[ -z "$TEMP_MANIFEST" ]] || rm -f -- "$TEMP_MANIFEST"
}

find_fstab_mountpoint() {
  local target="$1"
  local candidate
  local best=""

  while IFS= read -r candidate; do
    [[ "$candidate" != "/" ]] || continue
    if [[ "$target" == "$candidate" || "$target" == "$candidate/"* ]]; then
      if ((${#candidate} > ${#best})); then
        best="$candidate"
      fi
    fi
  done < <(findmnt --fstab --evaluate --raw --noheadings --output TARGET)

  printf '%s\n' "$best"
}

find_source_manifest() {
  local source_steamapps="$1"
  local installdir="$2"
  local candidate
  local line
  local manifest_installdir

  FOUND_MANIFEST=""
  for candidate in "$source_steamapps"/appmanifest_*.acf; do
    [[ -f "$candidate" ]] || continue
    manifest_installdir=""

    while IFS= read -r line; do
      if [[ "$line" =~ \"installdir\"[[:space:]]+\"([^\"]+)\" ]]; then
        manifest_installdir="${BASH_REMATCH[1]}"
        break
      fi
    done < "$candidate"

    [[ "$manifest_installdir" == "$installdir" ]] || continue
    [[ -z "$FOUND_MANIFEST" ]] || fail "multiple manifests use installdir '$installdir' in $source_steamapps"
    FOUND_MANIFEST="$candidate"
  done

  [[ -n "$FOUND_MANIFEST" ]]
}

trap cleanup EXIT

while (($# > 0)); do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      fail "unknown argument: $1"
      ;;
  esac
done

DESTINATION_STEAMAPPS="$LINUX_STEAM_ROOT/steamapps"
DESTINATION_COMMON="$DESTINATION_STEAMAPPS/common"
LOCK_FILE="${XDG_RUNTIME_DIR:-/tmp}/steam-library-sync-${UID}.lock"

exec 9>"$LOCK_FILE"
flock -n 9 || fail "another synchronization is already running"

[[ -d "$DESTINATION_COMMON" ]] || fail "Linux Steam library is missing at $DESTINATION_STEAMAPPS"

if pgrep -x steam >/dev/null || pgrep -x steamwebhelper >/dev/null; then
  fail "Steam is running; close it before synchronizing manifests"
fi

shopt -s nullglob
matched=0
changed=0

for destination_game in "$DESTINATION_COMMON"/*; do
  [[ -L "$destination_game" ]] || continue

  link_target="$(readlink -- "$destination_game")"
  if [[ "$link_target" == /* ]]; then
    source_game="$(realpath --canonicalize-missing -- "$link_target")"
  else
    source_game="$(realpath --canonicalize-missing -- "$(dirname -- "$destination_game")/$link_target")"
  fi

  source_common="$(dirname -- "$source_game")"
  source_steamapps="$(dirname -- "$source_common")"
  [[ "$(basename -- "$source_common")" == "common" ]] || continue
  [[ "$(basename -- "$source_steamapps")" == "steamapps" ]] || continue

  ((matched += 1))
  installdir="$(basename -- "$source_game")"
  [[ "$(basename -- "$destination_game")" == "$installdir" ]] || \
    fail "symlink name does not match its target directory: $destination_game"

  if [[ ! -d "$source_game" ]]; then
    mountpoint="$(find_fstab_mountpoint "$source_game")"
    [[ -n "$mountpoint" ]] || fail "target is unavailable and no parent mount is configured in /etc/fstab: $source_game"
    mountpoint -q -- "$mountpoint" && \
      fail "target does not exist on the mounted volume: $source_game"

    if ((DRY_RUN)); then
      log "$installdir: would mount $mountpoint; manifest cannot be checked until mounted"
      changed=1
      continue
    fi

    command -v pkexec >/dev/null || fail "pkexec is required to mount $mountpoint"
    log "$installdir: reloading systemd mount configuration"
    pkexec /usr/bin/systemctl daemon-reload || fail "could not reload systemd configuration"
    log "$installdir: requesting authorization to mount $mountpoint"
    pkexec /usr/bin/mount "$mountpoint" || fail "could not mount $mountpoint"
    [[ -d "$source_game" ]] || fail "game directory is still unavailable after mounting: $source_game"
  fi

  find_source_manifest "$source_steamapps" "$installdir" || \
    fail "no manifest with installdir '$installdir' exists in $source_steamapps"
  source_manifest="$FOUND_MANIFEST"
  appid="${source_manifest##*/appmanifest_}"
  appid="${appid%.acf}"
  [[ "$appid" =~ ^[0-9]+$ ]] || fail "invalid manifest filename: $source_manifest"
  grep -Eq '"appid"[[:space:]]+"'"$appid"'"' "$source_manifest" || \
    fail "manifest APPID mismatch: $source_manifest"

  destination_manifest="$DESTINATION_STEAMAPPS/appmanifest_${appid}.acf"
  if [[ -f "$destination_manifest" ]] && cmp -s -- "$source_manifest" "$destination_manifest"; then
    log "$appid ($installdir): manifest is current"
  elif ((DRY_RUN)); then
    log "$appid ($installdir): would synchronize manifest"
    changed=1
  else
    TEMP_MANIFEST="${destination_manifest}.tmp.$$"
    install -m 0644 -- "$source_manifest" "$TEMP_MANIFEST"
    touch -r "$source_manifest" "$TEMP_MANIFEST"
    mv -f -- "$TEMP_MANIFEST" "$destination_manifest"
    TEMP_MANIFEST=""
    log "$appid ($installdir): synchronized manifest"
    changed=1
  fi
done

((matched)) || fail "no Steam game-directory symlinks were found in $DESTINATION_COMMON"

if ((changed)); then
  ((DRY_RUN)) && log "dry run complete; changes are required" || log "synchronization complete"
else
  log "all discovered games are current"
fi
