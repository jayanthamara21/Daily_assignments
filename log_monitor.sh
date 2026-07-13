#!/bin/bash

# Environment Setup
LOG_DIR="./logs"
REPORT_DIR="./reports"
SCRIPT_LOG="./script_logs/script_execution.log"

DATE=$(date +%F)
REPORT_FILE="$REPORT_DIR/report_$DATE.txt"

mkdir -p "$REPORT_DIR" "./script_logs"

# Logging Function
write_log() {
    echo "[$(date '+%F %T')] [$1] $2" >> "$SCRIPT_LOG"
}

# Check Log Directory
check_directory() {
    [ ! -d "$LOG_DIR" ] && echo "Log folder missing!" && exit 1
    ls "$LOG_DIR"/*.log >/dev/null 2>&1 || { echo "No log files!"; exit 1; }
}

# Process Log File
process_log_file() {
    file=$1
    server=$(basename "$file" .log)

    info=$(awk '$3=="INFO"{c++} END{print c+0}' "$file")
    warn=$(awk '$3=="WARNING"{c++} END{print c+0}' "$file")
    error=$(awk '$3=="ERROR"{c++} END{print c+0}' "$file")

    if [ $error -gt 10 ]; then
        status="CRITICAL"
    elif [ $warn -gt 20 ]; then
        status="WARNING"
    else
        status="NORMAL"
    fi

    echo "$server  $info  $warn  $error  $status" >> "$REPORT_FILE"
}

# Generate Report
generate_report() {
    echo "Daily Server Health Report - $DATE" > "$REPORT_FILE"
    echo "SERVER INFO WARNING ERROR STATUS" >> "$REPORT_FILE"

    for file in "$LOG_DIR"/*.log
    do
        process_log_file "$file"
    done

    echo "Report saved in $REPORT_FILE"
}

# Menu
show_menu() {
    while true
    do
        echo "1. Analyze Logs"
        echo "2. Generate Report"
        echo "3. View Report"
        echo "4. Exit"

        read -p "Choice: " ch

        case $ch in
            1) check_directory ;;
            2) generate_report ;;
            3) cat "$REPORT_FILE" ;;
            4) exit ;;
            *) echo "Invalid Choice" ;;
        esac
    done
}

write_log "INFO" "Script Started"
show_menu