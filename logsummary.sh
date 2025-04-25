#Write a Bash script that analyzes a log file (e.g., access.log) and provides a summary with the following details:
#Total number of requests
#Number of unique IP addresses
#Top 5 IP addresses by request count
#Number of requests per HTTP status code (e.g., 200, 404, 500)
#Top 3 most requested URLs
---______________--------------__________---------_______------____---____---___---___--____---___---_____


#!/bin/bash

LOG_FILE="access.log"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file '$LOG_FILE' not found!"
  exit 1
fi

echo "Analyzing log file: $LOG_FILE"
echo "-------------------------------------------"

# Total number of requests
total_requests=$(wc -l < "$LOG_FILE")
echo "Total number of requests: $total_requests"

# Number of unique IP addresses
unique_ips=$(awk '{print $1}' "$LOG_FILE" | sort | uniq | wc -l)
echo "Number of unique IP addresses: $unique_ips"

# Top 5 IP addresses by request count
echo "Top 5 IP addresses by request count:"
awk '{print $1}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -5

# Number of requests per HTTP status code
echo "Number of requests per HTTP status code:"
awk '{print $9}' "$LOG_FILE" | grep -E '^[0-9]{3}$' | sort | uniq -c | sort -n

# Top 3 most requested URLs
echo "Top 3 most requested URLs:"
awk '{print $7}' "$LOG_FILE" | sort | uniq -c | sort -nr | head -3
