#Write a Bash script that:
#Accepts a directory path as a command-line argument.
#Checks if the directory exists. If it does not exist, print an error and exit.
#Counts the number of files and directories inside the given directory.
#Displays the total size of the directory in a human-readable format.
#Saves the output in a log file named directory_report.log with a timestamp.
#-----------------------------------------------------------------------------------------------------------------------
#!/bin/bash

# check  if adirectory path is provided

if [ -z "$1" ]; then
   echo "Usages : $0 <directory_path>"
   exit 1
fi

# Assign the directory path to a variable
directory="$1"

# Check if the provided argument is a valid directory
if [ ! -d "$directory" ]; then
    echo "Error: '$directory' is not a valid directory."
    exit 1
fi

# Print the directory path
echo "Directory path provided: $directory"

# Count the number of files and directories inside the given directory
num_files=$(find "$directory" -type f | wc -l)
num_dirs=$(find "$directory" -type d | wc -l)

echo "Number of files: $num_files"
echo "Number of directories: $num_dirs"

#Displays the total size of the directory in a human-readable format.
Total_Size=$(du -sh "$directory" | cut -f1)
echo "Total size of the files and directory: $Total_Size"

#Saves the output in a log file named directory_report.log with a timestamp.
timestamp=$(date "+%Y-%m-%d|%H:%M:%S")
log_file="directory_report_$timestamp.log"

echo"[timestamp] Directory : $directory" >> "$log_file"
echo"[timestamp] No. of files : $num_files" >> "$log_file"
echo"[timestamp] No. of directory : $num_directory" >> "$log_file"
echo"[timestamp] Total Size : $Total_Size" >> "$log_file"
echo"[timestamp] Report save to $log_file"
