#!/bin/bash

# Prompt user for start and end time (HH:MM format)
read -p "Enter start time (HH:MM): " start_time
read -p "Enter end time (HH:MM): " end_time

# Convert time to sortable form (HHMM)
start_t=$(echo "$start_time" | tr -d :)
end_t=$(echo "$end_time" | tr -d :)

# Generate timestamp for unique output filename
timestamp=$(date +"%Y%m%d_%H%M%S")
output_log="context_blocks_bw_${start_t}and${end_t}_output_$timestamp.log"
> "$output_log"  # Clear old log

echo "Searching files between $start_time and $end_time..."

# Loop through all .txt files
for file in *.txt; do
    # Extract time string from filename (format: ..._HH-MM-SS_...)
    if [[ $file =~ _([0-9]{2})-([0-9]{2})-[0-9]{2}_ ]]; then
        file_hour=${BASH_REMATCH[1]}
        file_min=${BASH_REMATCH[2]}
        file_time="${file_hour}${file_min}"

        # Check if file time is in range
        if [[ "$file_time" -ge "$start_t" && "$file_time" -le "$end_t" ]]; then
            echo "Processing $file (time $file_hour:$file_min)"

            # Find last tag positions
            start_line=$(grep -nF "<current_context>" "$file" | tail -n 1 | cut -d: -f1)
            end_line=$(grep -nF "</current_context>" "$file" | tail -n 1 | cut -d: -f1)

            # Ensure valid tag positions
            if [ -z "$start_line" ] || [ -z "$end_line" ] || [ "$start_line" -ge "$end_line" ]; then
                echo "  Skipping $file (tags missing or out of order)." >> "$output_log"
                continue
            fi

            # Append to log
            {
                echo "-----------------------------------------------------------------------------------------------------------------------------------"
                echo "------------ Extracted Block from $file --------------"
                echo "-----------------------------------------------------------------------------------------------------------------------------------"
                sed -n "${start_line},${end_line}p" "$file"
                echo
            } >> "$output_log"
        fi
    fi
done

echo
echo "--------------------------------------------------------------------"
echo "Filtered context blocks written to $output_log"
echo
