#!/bin/bash

base_dir="."

find "$base_dir" -type f -name "dconf.conf" | while read -r file; do
  relative_path="${file#$base_dir/}"
  dir_path=$(dirname "$relative_path")
  dconf_path="/${dir_path}"
  dconf_path=$(echo "$dconf_path" | sed 's|//|/|g')

  echo "🔁 Loading $file → $dconf_path"
  dconf load "$dconf_path/" < "$file"
done