#!/bin/bash

# Loop through all .txt files in the current directory
for file in *.txt; do
    echo "Processing file: $file"

    # Get the last line number of <current_context>
    start_line=$(grep -nF "<current_context>" "$file" | tail -n 1 | cut -d: -f1)

    # Get the last line number of </current_context>
    end_line=$(grep -nF "</current_context>" "$file" | tail -n 1 | cut -d: -f1)

    # If either tag is missing, skip the file
    if [ -z "$start_line" ] || [ -z "$end_line" ]; then
        echo "  One or both tags not found. Skipping."
        continue
    fi

    # Print the extracted block
    echo "  Start line: $start_line"
    echo "  End line: $end_line"
    echo "  ----- Extracted Block from $file -----"
    sed -n "${start_line},${end_line}p" "$file"
    echo
done
