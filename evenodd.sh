#Write a script to accept a number as input and check if it's even or odd.
#! /bin/bash
read -p "Enter the any number to find even and odd: " num

if [ $((num % 2)) -eq 0  ];
then 
    echo "$num is Even"
else
    echo "$num is odd"
fi
