#!/bin/bash
# Show total file size and file count per entry (max-depth=1)

TARGET="${1:-.}"

printf "%-50s %10s %10s\n" "PATH" "SIZE" "FILES"
printf "%s\n" "----------------------------------------------------------------------"

while IFS=$'\t' read -r size path; do
    if [ "$path" = "$TARGET" ]; then
        continue
    fi
    count=$(find "$path" -type f 2>/dev/null | wc -l)
    printf "%-50s %10s %10s\n" "$path" "$size" "$count"
done < <(du -sh --max-depth=1 "$TARGET" 2>/dev/null | sort -rh)

# Total
total_size=$(du -sh "$TARGET" 2>/dev/null | cut -f1)
total_files=$(find "$TARGET" -type f 2>/dev/null | wc -l)
printf "%s\n" "----------------------------------------------------------------------"
printf "%-50s %10s %10s\n" "TOTAL" "$total_size" "$total_files"
