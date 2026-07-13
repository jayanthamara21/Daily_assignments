
ORDER_DIR="./orders"
REPORT_DIR="./reports"
ALERT_DIR="./alert_logs"

DATE=$(date +%Y-%m-%d)

REPORT_FILE="$REPORT_DIR/sales_$DATE.csv"
ALERT_LOG="$ALERT_DIR/alert_log.txt"

mkdir -p "$REPORT_DIR"
mkdir -p "$ALERT_DIR"


declare -a STORE
declare -a REVENUE
declare -a ORDERS
declare -a FAILED
declare -a STATUS

INDEX=0


write_alert() {
    local level="$1"
    local msg="$2"

    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg" >> "$ALERT_LOG"
}

# ---------- Task 02 : Validate Files ----------
validate_files() {

    if [ ! -d "$ORDER_DIR" ]; then
        write_alert "ERROR" "Order directory not found."
        echo "Order directory not found."
        exit 1
    fi

    if ! ls "$ORDER_DIR"/*.csv >/dev/null 2>&1; then
        write_alert "ERROR" "No CSV files found."
        echo "No CSV files found."
        exit 1
    fi

    for file in "$ORDER_DIR"/*.csv
    do
        if [ ! -s "$file" ]; then
            write_alert "ERROR" "$file is empty."
            echo "$file is empty."
            exit 1
        fi
    done

    write_alert "INFO" "Input validation successful."
}

# ---------- Task 03,04,05,06,07 ----------
process_store() {

    local csv_file="$1"

    store=$(basename "$csv_file" .csv)

    # Nested Loop
    while IFS=',' read -r order_id date status category amount
    do
        [ "$order_id" = "OrderID" ] && continue

        # Any extra processing can be done here

    done < "$csv_file"

    # grep counts
    failed_count=$(grep -c ",FAILED," "$csv_file")
    pending_count=$(grep -c ",PENDING," "$csv_file")
    refund_count=$(grep -c ",REFUNDED," "$csv_file")

    echo "Store : $store"
    echo "Failed : $failed_count"
    echo "Pending : $pending_count"
    echo "Refunded : $refund_count"

    # Top completed orders
    echo "Top 5 Completed Order Amounts"

    grep ",COMPLETED," "$csv_file" |
    cut -d',' -f5 |
    sort -nr |
    head -5

    # Revenue
    revenue=$(awk -F',' '$3=="COMPLETED"{sum+=$5} END{printf "%.2f",sum}' "$csv_file")

    # Total Orders
    total=$(awk 'END{print NR-1}' "$csv_file")

    # Average Revenue
    avg=$(awk -F',' '
        $3=="COMPLETED"{
            sum+=$5
            count++
        }
        END{
            if(count>0)
                printf "%.2f",sum/count
            else
                print 0
        }' "$csv_file")

    echo "Revenue : ₹$revenue"
    echo "Average : ₹$avg"

    # Health Status
    if [ "$failed_count" -gt 30 ]; then
        health="CRITICAL"
        write_alert "CRITICAL" "$store has too many failed orders."

    elif [ "$refund_count" -gt 20 ]; then
        health="WARNING"
        write_alert "WARNING" "$store has high refunds."

    else
        health="OK"
        write_alert "INFO" "$store operating normally."
    fi

    STORE[$INDEX]=$store
    REVENUE[$INDEX]=$revenue
    ORDERS[$INDEX]=$total
    FAILED[$INDEX]=$failed_count
    STATUS[$INDEX]=$health

    INDEX=$((INDEX+1))
}

# ---------- Task 08 : Generate CSV ----------
generate_csv() {

    echo "Store/Category,Revenue,Orders,Failed,Status" > "$REPORT_FILE"

    for ((i=0;i<INDEX;i++))
    do
        echo "${STORE[$i]},₹${REVENUE[$i]},${ORDERS[$i]},${FAILED[$i]},${STATUS[$i]}" >> "$REPORT_FILE"
    done

    echo
    echo "CSV Report Generated Successfully"
    echo "$REPORT_FILE"

    write_alert "INFO" "CSV report generated."
}

# ---------- Process Today's Orders ----------
process_orders() {

    INDEX=0

    validate_files

    for file in "$ORDER_DIR"/*.csv
    do
        process_store "$file"
        echo
    done
}

# ---------- Task 10 : Menu ----------
show_menu() {

while true
do
    echo
    echo "======================================="
    echo " E-Commerce Sales Monitoring System"
    echo "======================================="
    echo "1. Process Today's Orders"
    echo "2. Generate CSV Report"
    echo "3. View Alert Log"
    echo "4. Exit"
    echo "======================================="

    read -p "Select [1-4]: " choice

    case $choice in

        1)
            process_orders
            ;;

        2)
            generate_csv
            ;;

        3)
            cat "$ALERT_LOG"
            ;;

        4)
            write_alert "INFO" "Program exited."
            echo "Goodbye!"
            exit 0
            ;;

        *)
            echo "Invalid Choice."
            ;;
    esac

done

}

# ---------- Main ----------
write_alert "INFO" "Script Started"

show_menu