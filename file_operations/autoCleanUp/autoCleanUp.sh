#!/bin/bash

# === Configuration ===
LOG_DIR="/home/ANT.AMAZON.COM/mukeswin/Downloads/release-neptune-NS6631_userdebug_S713/scripts"
DAYS_TO_KEEP=7
SLEEP_INTERVAL_MINUTES=60
IP_LIST=("192.168.1.10" "192.168.1.11")

while true; do
    TODAY=$(date +%Y%m%d)
    CUTOFF_DATE=$(date -d "$DAYS_TO_KEEP days ago" +%Y%m%d)

    cd "$LOG_DIR" || {
        echo "Error: Cannot access log directory $LOG_DIR"
        sleep "${SLEEP_INTERVAL_MINUTES}m"
        continue
    }

    for IP in "${IP_LIST[@]}"; do
        echo "Checking for today's logs for IP: $IP"

        if ls "${TODAY}"*"$IP"/ &>/dev/null; then
            echo "Today's logs found for $IP — cleaning up old logs"

            for dir in */; do
                if [[ "$dir" =~ ^([0-9]{8})[0-9]{4}$IP/?$ ]]; then
                    FOLDER_DATE="${BASH_REMATCH[1]}"
                    if [[ "$FOLDER_DATE" < "$CUTOFF_DATE" ]]; then
                        echo "Deleting folder: $dir (Date: $FOLDER_DATE for IP: $IP)"
                        rm -rf "$dir"
                    fi
                fi
            done
        else
            echo "Today's logs missing for $IP. Skipping cleanup for this IP."
        fi
    done

    echo "Cleanup cycle finished at $(date)"
    echo "Sleeping for $SLEEP_INTERVAL_MINUTES minutes..."
    sleep "${SLEEP_INTERVAL_MINUTES}m"
done
