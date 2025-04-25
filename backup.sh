#!/bin/bash

# Prompt the user to enter the name of the file to back up
echo "Enter the name of the file to back up:"
read filename

# Check if the specified file exists
if [ -f "$filename" ]; then
    # Create a backup filename by appending the current date and time
    backup_filename="${filename%.*}_$(date +"%Y-%m-%d_%H%M%S").${filename##*.}"
    
    # Copy the contents of the original file to the backup file
    cp "$filename" "$backup_filename"
    
    # Print a message indicating the backup process is completed
    echo "Backup created: $backup_filename"
else
    echo "Error: File not found or does not exist."
fi
