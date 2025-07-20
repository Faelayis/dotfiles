#!/bin/bash

extensions_dirs=(
  "$HOME/.local/share/gnome-shell/extensions"
  "/usr/share/gnome-shell/extensions"
)

output="gnome-extensions.json"
temp_output="${output}.tmp"

echo "[" > "$temp_output"

first=true
declare -A found_uuids

for dir in "${extensions_dirs[@]}"; do
  [ ! -d "$dir" ] && continue

  for ext_path in "$dir"/*; do
    [ ! -d "$ext_path" ] && continue

    uuid=$(basename "$ext_path")
    metadata_file="$ext_path/metadata.json"

    [ ! -f "$metadata_file" ] && continue

    if [[ -n "${found_uuids[$uuid]}" ]]; then
      continue
    fi

    found_uuids[$uuid]=1

    name=$(jq -r '.name // ""' "$metadata_file")
    version=$(jq -r '.version // ""' "$metadata_file")
    enabled=$(gnome-extensions list --enabled 2>/dev/null | grep -q "$uuid" && echo true || echo false)

    [ "$first" = true ] && first=false || echo "," >> "$temp_output"
    echo "  {" >> "$temp_output"
    echo "    \"uuid\": \"$uuid\"," >> "$temp_output"
    echo "    \"name\": \"$name\"," >> "$temp_output"
    echo "    \"version\": \"$version\"," >> "$temp_output"
    echo "    \"enabled\": $enabled" >> "$temp_output"
    echo -n "  }" >> "$temp_output"
  done
done

echo "" >> "$temp_output"
echo "]" >> "$temp_output"


jq 'unique_by(.uuid)' "$temp_output" > "$output"

rm "$temp_output"

echo "✅ Exported extension metadata safely to $output"