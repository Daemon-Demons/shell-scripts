#!/bin/bash

# Define output log file
output_log="context_blocks.log"

# Clear log file at the beginning
> "$output_log"

# Loop through all .txt files
for file in *.txt; do
    echo "Processing file: $file"

    # Get last occurrence line numbers
    start_line=$(grep -nF "<current_context>" "$file" | tail -n 1 | cut -d: -f1)
    end_line=$(grep -nF "</current_context>" "$file" | tail -n 1 | cut -d: -f1)

    # Skip if tags not found or in wrong order
    if [ -z "$start_line" ] || [ -z "$end_line" ] || [ "$start_line" -ge "$end_line" ]; then
        echo "  Skipping $file (tags missing or out of order)." >> "$output_log"
        continue
    fi

    # Append header to log
    {
        #echo "File: $file"
        #echo "Start line: $start_line"
        #echo "End line: $end_line"
        echo "-------------------------------------------------------------------------------------------------------"
        echo "------------ Extracted Block from $file --------------"
        echo "------------------------------------------------------------------------------------------------------"
        sed -n "${start_line},${end_line}p" "$file"
        echo    # Blank line after each block
    } >> "$output_log"

    echo "  Block from $file written to log."
done

echo "All context blocks saved to $output_log"
