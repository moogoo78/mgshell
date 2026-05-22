#!/bin/bash

# Define an associative array of commands and their corresponding names
declare -A commands
commands[node]="Node.js"
commands[npm]="NPM"
commands[python3]="Python"
commands[git]="Git"
commands[docker]="Docker"
commands[java]="Java"

# Loop through the commands and check their versions
for cmd in "${!commands[@]}"; do
    if command -v "$cmd" &> /dev/null; then
        echo "✅ ${commands[$cmd]} is installed. Version:"
        echo "  $("$cmd" --version)"
    else
        echo "❌ ${commands[$cmd]} is not installed."
    fi
    echo "" # Add a blank line for better readability
done
