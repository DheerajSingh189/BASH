#!/bin/bash

# Check if the filename is provided
#if [ -z "$1" ]; then
  #  echo "Usage: $0 filename"
 #   exit 1
#fi

# Assign the first argument to a variable
#FILENAME=$1
# Getting USer input 
read -p "Enter the filename who's permission youn want to change: " FILENAME

# Check if the file exists
if [ -e "$FILENAME" ]; then
    echo "File '$FILENAME' exists."

    # Prompt the user for the desired permissions
    echo "Please enter the permissions you want to set for the file (e.g., 755, 644, 600, etc.):"
    read PERMISSIONS

    # Validate the provided permissions
    case "$PERMISSIONS" in
        [0-7][0-7][0-7])
            echo "Changing file permissions to $PERMISSIONS..."
            sudo chmod "$PERMISSIONS" "$FILENAME"
            echo "Permissions changed successfully."
            ;;
        *)
            echo "Invalid permissions: $PERMISSIONS"
            echo "Please enter a valid permission in the format of three digits (0-7)."
            ;;
    esac
else
    echo "File '$FILENAME' does not exist."
    exit 1
fi
