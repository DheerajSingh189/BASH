#! /bin/bash/
# colour code for colored text for better readability.
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
NC="\e[0m" 
white="\e[47m"

read -p "Enter the file name you want to Search: " file   # Prompt for the file name

file_found=$(find / -type f -name "$file" 2>/dev/null) #  Use 'find' to search for the file in all directories

if [ -n "$file_found" ];  # Check if any files were found
then 
   echo "${white}${BLUE}Found the File(s) '$file'${NC}${NC}"
   echo  "${GREEN}Found the File(s) '$file' at:${NC}"

   for file in $file_found; do  # Loop through each found file and display its path and contents
      echo "${RED}path: ${NC}${GREEN}$file${NC}"
      echo "${GREEN}Contents:${NC}"
	cat "$file"
	echo  "\n------------------------------\n"    # Separator for readability
   done
else  
     echo  "${RED}$file is not exist in out records${NC}"
fi
