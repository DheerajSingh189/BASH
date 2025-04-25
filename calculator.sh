
#!/bin/bash
# Define color codes using tput
SKY_BLUE="\e[96m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m" 

# Define a function to add two numbers
add_numbers() {
  res=$((num1 + num2))
  echo "${YELLOW}Sum of $num1 and $num2 is: $res ${RESET}"
  echo
}

sub() {
    res=$((num1 - num2))
    echo "${YELLOW} Subtraction of $num1 and $num2 is: $res ${RESET}"
    echo 
}


mul() {
  
  res=$((num1 * num2))
  echo "${YELLOW} multipication of $num1 and $num2 is: $res ${RESET}" 
  echo
}

div() {
   if [ "$num2" -eq 0 ]
   then
  echo "Error: Division by zero is not allowed."
else
  # Perform the division and print the result
  res=$(awk "BEGIN {printf \"%.2f\", $num1 / $num2}")
  echo "${YELLOW} Division of $num1 and $num2 is: $res ${RESET}"
fi
    
    echo
}

while true
do
   echo "Choice any of opration you wants : "
   echo "1) Addition"
   echo "2) Subtraction"
   echo "3) Multiplicatiom"
   echo "4) Division"
   echo "5) Quit"
   echo

read -p "Enter the your choice  from given menu :" choice

 case $choice in
 1)
# Prompt the user for input
  read -p "Enter the first number: " num1
  read -p "Enter the second number: " num2
  add_numbers
  ;;

 2)
  read -p "Enter the first number: " num1
  read -p "Enter the second number: " num2
  sub
  ;;
 3)
  read -p "Enter the first number: " num1
  read -p "Enter the second number: " num2
  mul
  ;;
 4)
  read -p "Enter the dividend: " num1
  read -p "Enter the divisor: " num2
  div
  ;;
 5) echo "${SKY_BLUE}Good Bye : ${RESET})"
    exit 
    ;;
 *) echo "  ${RED}-------Warning-----${RESET}"
    echo "     Invalid choice"
    echo
   ;;
 esac
done
