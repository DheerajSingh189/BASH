#You have a directory /var/logs/app/ containing hundreds of log files. 
# You want to archive all .log files older than 7 days into a compressed tar.gz file and move it to /backup/logs/.
#Task: Write a bash script to do this automatically. provide tip that help me to write a scritp
#_________________________________________________________________________________________________________________________________

#!/bin/bash
LOG_DIR="/var/log/syslog"
BACKUP_DIR="/var/backup/log"
ARCHIVE_NAME="logs.$(date+%F).tar.gz"

# creating  Backup Directory exists
sudo  mkdir -p  "$BACKUP_DIR"

# Find and archive files older than 7 days	
FILE=$(find  $LOG_DIR -name "*.log" -type f -mtime +60) 

if  [ -n "$FILE" ]; then 
	tar -czvf "$BACKUP_DIR/$ARCHIVE_NAME" $FILE
	# Removing Orignal Log files
	find "$LOG_DIR" -name "*.log" -type f -mtime +60 -exec rm {} \;
	echo "archived and cleared old log file"
else
	echo "no file are older then 7 days" 
fi
