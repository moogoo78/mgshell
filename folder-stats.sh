#!/bin/bash
# Show total file size and file count per top-level subdirectory, sorted by size

TARGET="${1:-.}"

# Collect byte sizes per entry
declare -A sizes=()
total_size=0
while IFS=$'\t' read -r size path; do
    if [ "$path" = "$TARGET" ]; then
        total_size="$size"
        continue
    fi
    sizes["$path"]="$size"
done < <(du -b --max-depth=1 "$TARGET" 2>/dev/null)

# Single find pass for file counts
declare -A counts=()
total_files=0
while IFS= read -r -d '' file; do
    rel="${file#"$TARGET"/}"
    dir="${rel%%/*}"
    key="$TARGET/$dir"
    counts["$key"]=$(( ${counts["$key"]:-0} + 1 ))
    (( total_files++ ))
done < <(find "$TARGET" -maxdepth 1 -mindepth 1 -not -type d -print0 2>/dev/null; find "$TARGET" -mindepth 2 -type f -print0 2>/dev/null)

# Sort entries by size descending
sorted=$(for p in "${!sizes[@]}"; do
    printf '%s\t%s\n' "${sizes[$p]}" "$p"
done | sort -rn)

# Print header
printf "%-55s %10s %10s\n" "PATH" "SIZE" "FILES"
printf "%s\n" "------------------------------------------------------------------------------"

# Print rows
while IFS=$'\t' read -r size path; do
    [ -z "$path" ] && continue
    human=$(numfmt --to=iec-i --suffix=B "$size")
    printf "%-55s %10s %10s\n" "$path" "$human" "${counts[$path]:-0}"
done <<< "$sorted"

# Print total
printf "%s\n" "------------------------------------------------------------------------------"
human_total=$(numfmt --to=iec-i --suffix=B "$total_size")
printf "%-55s %10s %10s\n" "TOTAL" "$human_total" "$total_files"
