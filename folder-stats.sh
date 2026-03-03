#!/bin/bash
# Show total file size and file count per entry (max-depth=1)

TARGET="${1:-.}"

# Single find pass: count files per top-level subdirectory
declare -A counts
total_files=0
while IFS= read -r -d '' file; do
    rel="${file#"$TARGET"/}"
    dir="${rel%%/*}"
    counts["$TARGET/$dir"]=$(( ${counts["$TARGET/$dir"]:-0} + 1 ))
    (( total_files++ ))
done < <(find "$TARGET" -type f -print0 2>/dev/null)

printf "%-50s %10s %10s\n" "PATH" "SIZE" "FILES"
printf "%s\n" "----------------------------------------------------------------------"

while IFS=$'\t' read -r size path; do
    if [ "$path" = "$TARGET" ]; then
        continue
    fi
    printf "%-50s %10s %10s\n" "$path" "$size" "${counts[$path]:-0}"
done < <(du -sh --max-depth=1 "$TARGET" 2>/dev/null | sort -rh)

# Total
total_size=$(du -sh "$TARGET" 2>/dev/null | cut -f1)
printf "%s\n" "----------------------------------------------------------------------"
printf "%-50s %10s %10s\n" "TOTAL" "$total_size" "$total_files"
