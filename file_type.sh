##Write a Shell Bash Script for evaluate the status of a file/directory.
# test-file: Evaluate the status of a file

#! /bin/bash

read -p "Enter the File/Directory name (using the absolute path)?" file
echo

if [ -e "$file" ]; then
    if  [ -w "$file" ]; then 
        echo " $file is writable file"
    fi
    if  [ -r "$file" ]; then
        echo "$file is readable."
    fi
    if [ -f "$file" ]; then
        echo " $file is regular file."
    fi
    if [ -d "$file" ]; then
        echo "$file is directory."
    fi
    if [ -x "$file" ]; then
        echo "$file is executable/searchable file."
    fi
else 
    echo "$file does not exist."
    exit 1
fi
