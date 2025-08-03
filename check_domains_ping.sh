Write a Bash script that:
#Monitors the CPU and memory usage of the system every 5 seconds.
#Logs the usage data into a file named system_monitor.log with timestamps.
#If the CPU usage exceeds 80% or the available memory falls below 500MB, the script should send an alert message to the terminal.
#The script should keep running indefinitely until manually stopped.

#!/bin/bash

LOG_FILE="System_monitor.log"
ALTER_LOG="alert.log"
THERSHOLD_CPU=80.0
THERSHOLD_MEM_MB=500

while true;do
	#Timestamp
	timestamp=$(date '+%Y-%m-%d %H:%M:%S')

	#CPU usage:
	cpu_idle=$(top -bn1 | grep "Cpu(s)" | awk -F',' '{
    for (i=1; i<=NF; i++) {
        gsub(/^ +| +$/, "", $i)  # trim spaces
        print $i
    }
}'
)
cpu_usage=$(echo "100-$cpu_idle" | bc)

#Available  memory in MB 

mem_available=$(free -m | awk '/Mem:/ {print $7}')
#Log system usage
echo "$timestamp CPU Usage: $cpu _usage% | Available Memory: ${Mem_avilable}MB" >> "LOG_FILE"

  # Alert message (if triggered)
    if (( $(echo "$cpu_usage > $THRESHOLD_CPU" | bc -l) )); then
        alert="[$timestamp] High CPU usage: $cpu_usage%"
        echo "$alert"
        echo "$alert" >> "$ALERT_LOG"
    fi

    if (( mem_available < THRESHOLD_MEM_MB )); then
        alert="[$timestamp] Low available memory: ${mem_available}MB"
        echo "$alert"
        echo "$alert" >> "$ALERT_LOG"
    fi

    sleep 5
done
