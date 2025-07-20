#!/bin/bash

paths=(
   "/org/gnome/gnome-session/"
   "/org/gnome/shell/extensions/"
   "/org/gnome/desktop/interface/"
   "/org/gnome/desktop/wm/keybindings/"
   "/org/gnome/settings-daemon/plugins/media-keys/"
)

blacklist_paths=(
  "/org/gnome/shell/extensions/[quicksettings-audio-devices-hider]"
)

blacklist_properties=(
   "/org/gnome/shell/extensions/[simple-weather].locations"
   "/org/gnome/shell/extensions/[dash-to-panel].primary-monitor"
   "/org/gnome/shell/extensions/[toggle-audio].output-devices-available"
)

for path in "${paths[@]}"; do
   if [[ "$path" == \!* ]]; then
      echo "⏩ Skipping blacklisted path: ${path:1}"
      continue
   fi

   cleaned_path=$(echo "$path" | sed 's|:||g')
   relative_path=$(echo "$cleaned_path" | sed 's|^/||')
   full_dir="./$relative_path"

   mkdir -p "$full_dir"
   dconf dump "$path" > "$full_dir/dconf.conf"

   blacklist_sections=()

   for bp in "${blacklist_paths[@]}"; do
      if [[ "$bp" =~ ^/ ]]; then
         base_path="${bp%\[*}"
         if [[ "$path" == "$base_path" ]]; then
            sec=$(echo "$bp" | grep -oP '\[\K[^\]]+')
            blacklist_sections+=("$sec")
         fi
      else
         sec=$(echo "$bp" | grep -oP '\[\K[^\]]+')
         blacklist_sections+=("$sec")
      fi
   done

   if [[ ${#blacklist_sections[@]} -gt 0 ]]; then
      input_file="$full_dir/dconf.conf"
      tmp_file="${input_file}.tmp"

      awk -v RS= -v ORS="\n\n" -v sections="$(IFS="|"; echo "${blacklist_sections[*]}")" '
      BEGIN {
         split(sections, a, "|");
         for (i in a) remove[a[i]] = 1;
      }
      {
         match($0, /^\[([^\]]+)\]/, m);
         section = m[1];
         if (section in remove) found[section] = 1;
         if (!(section in remove))
            print $0;
      }
      END {
         for (sec in found) {
            print "FOUND_SECTION_TO_REMOVE:" sec > "/dev/stderr"
         }
      }
      ' "$input_file" > "$tmp_file" 2> found_sections.log

      if ! cmp -s "$input_file" "$tmp_file"; then
         mv "$tmp_file" "$input_file"
         mapfile -t found_sections < <(grep "^FOUND_SECTION_TO_REMOVE:" found_sections.log | cut -d: -f2)
         for section in "${found_sections[@]}"; do
            echo "🧹 Removed [$section] section from $input_file"
         done
      else
         rm "$tmp_file"
      fi

      rm -f found_sections.log
   fi

   property_filter_str=""

   declare -A prop_filter_map=()

   for bp in "${blacklist_properties[@]}"; do
      bp_path=$(echo "$bp" | grep -oP '^/.+(?=\[)')
      bp_section=$(echo "$bp" | grep -oP '\[\K[^\]]+')
      bp_property=$(echo "$bp" | grep -oP '\]\.\K.+')

      if [[ "$path" == "$bp_path" ]]; then
         if [[ -z "${prop_filter_map[$bp_section]}" ]]; then
            prop_filter_map[$bp_section]="$bp_property"
         else
            prop_filter_map[$bp_section]+="|$bp_property"
         fi
      fi
   done

   for sec in "${!prop_filter_map[@]}"; do
      if [[ -z "$property_filter_str" ]]; then
         property_filter_str="$sec=${prop_filter_map[$sec]}"
      else
         property_filter_str+=";$sec=${prop_filter_map[$sec]}"
      fi
   done

   if [[ -n "$property_filter_str" ]]; then
      input_file="$full_dir/dconf.conf"
      tmp_file="${input_file}.tmp"

      awk -v filter_str="$property_filter_str" '
      BEGIN {
         FS = "\n"
         RS = ""

         n = split(filter_str, pairs, ";")
         for (i = 1; i <= n; i++) {
            split(pairs[i], kv, "=")
            section = kv[1]
            props = kv[2]
            prop_map[section] = props
         }
      }
      {
         section_line = $1
         match(section_line, /^\[([^\]]+)\]/, m)
         current_section = m[1]

         if (!(current_section in prop_map)) {
            print $0 "\n"
            next
         }

         split($0, lines, "\n")
         printf "%s\n", lines[1]

         regex = "^(" prop_map[current_section] ")="

         for (i=2; i <= length(lines); i++) {
            if (lines[i] ~ regex) {
               continue
            }
            print lines[i]
         }
         print ""
      }
      ' "$input_file" > "$tmp_file"

      if ! cmp -s "$input_file" "$tmp_file"; then
         mv "$tmp_file" "$input_file"
         echo "🧹 Removed blacklisted properties ($property_filter_str) from $input_file"
      else
         rm "$tmp_file"
      fi
   fi

   echo "✅ Dumped $path → $full_dir/dconf.conf"
done
