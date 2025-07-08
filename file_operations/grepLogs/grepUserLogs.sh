#!/bin/bash

# Define the target strings
open_tag="<current_context>"
close_tag="</current_context>"

# Loop through all .txt files in the current directory
for file in *.txt; do
    echo "Searching in: $file"

    # Find lines containing <current_context>
    grep -nF "$open_tag" "$file" | awk -F: -v tag="$open_tag" '{ print $1 }'

    # Find lines containing </current_context>
    grep -nF "$close_tag" "$file" | awk -F: -v tag="$close_tag" '{ print $1 }'
done
