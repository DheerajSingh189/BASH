#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
  echo "[-] Please run as sudo"
  exit 1
fi

all_users=()
AUDIT_FILE=audit_April.txt
touch $AUDIT_FILE

printf "Hostname\n----------------------------------------\n" > $AUDIT_FILE
printf "$(hostname)\n\n" >> $AUDIT_FILE

printf "IP\n----------------------------------------\n" >> $AUDIT_FILE
printf "$(curl -s ipinfo.io/ip)\n\n" >> $AUDIT_FILE

printf "\n\nUsers with Recent Login\n----------------------------------------\n" >> $AUDIT_FILE
while read -r username; do
  if [[ $username != "nobody" ]]; then
    all_users+=($username)
    last_login=$(lastlog -u "$username" | awk 'FNR==2{print}')
    if [[ -n $last_login ]]; then
      printf "%s\n" "$last_login" >> $AUDIT_FILE
    fi
  fi
done < <(awk -F: '$3 >= 1000 {print $1}' /etc/passwd)


# printf "\n\nUsers with Recent Login\n----------------------------------------\n" >> $AUDIT_FILE
# printf "Username\t\tPort\t\tFrom\t\tLatest\n" >> $AUDIT_FILE
#for i in $(awk -F: '$3 >= 1000 {print $1}' /etc/passwd) root; do
#  if [[ $i != "nobody" ]]; then
#     all_users+=($i)
#     lastlog -u $i | awk 'FNR==2{print}' >> $AUDIT_FILE
#   fi
# done

printf "\n\nUsers with sudo permission\n----------------------------------------\n" >> $AUDIT_FILE
sudo grep -Po '^sudo.+:\K.*$' /etc/group >> $AUDIT_FILE
# for i in "${all_users[@]}"; do
#   if sudo -l -U $i | grep -v "not allowed" >/dev/null 2>&1; then
#     printf "%s\n" "$i" >> $AUDIT_FILE
#   fi
# done

printf "\n\nOS Name\n----------------------------------------\n" >> $AUDIT_FILE
head -2 /etc/os-release >> $AUDIT_FILE

printf "\n\nListening Ports\n----------------------------------------\n" >> $AUDIT_FILE
#ss -4tulp | awk 'NR>1{gsub(/.*:/,"",$5);print $1,$5,$NF}' | column -t >> $AUDIT_FILE
ss -4tulp  | column -t >> $AUDIT_FILE

printf "\n\n>>List by CPU usage\n" >> $AUDIT_FILE
ps axo pid,user,pcpu,pmem,comm --sort=-%cpu | head -n 20 | column -t | awk '{print $3,$4,$5}' >> $AUDIT_FILE
printf "\n>>List by Memory usage\n" >> $AUDIT_FILE
ps axo pid,user,pcpu,pmem,comm --sort=-%mem | head -n 20 | column -t | awk '{print $3,$4,$5}' >> $AUDIT_FILE

printf "\n\nCron Jobs\n----------------------------------------\n" >> $AUDIT_FILE
for user in $(cut -f1 -d: /etc/passwd); do
  crontab=$(sudo crontab -u "$user" -l 2>/dev/null)
  if [ -n "$crontab" ]; then
    printf "\n%s user cronjobs\n" "$user" >> $AUDIT_FILE
    echo "$crontab" | grep -v "^#" >> $AUDIT_FILE
  fi
done
# for i in "${all_users[@]}"; do
#   printf "\n%s user cronjobs\n" "$i" >> $AUDIT_FILE
#   crontab -u $i -l | grep -v "^#" >> $AUDIT_FILE
# done

# printf "\n\nUsers Password Expire Policy\n----------------------------------------\n" >> $AUDIT_FILE
# printf "User\t Password Change Date\t Password Expire Date\n" >> $AUDIT_FILE
# while read i; do
# 	USER_EXPIRE_DATE=$(sudo chage -l $i | grep 'Password expires' | cut -d':' -f2)
# 	LAST_PASS_CHANGE=$(sudo chage -l $i | grep 'Last password change' | cut -d':' -f2)
# 	CHANGE_DATE=$(date -d "$LAST_PASS_CHANGE" +%F)
# 	EXPIRE_DATE=$(date -d "$USER_EXPIRE_DATE" +%F)
# 	echo -e "$i\t\t $CHANGE_DATE\t\t $EXPIRE_DATE">> $AUDIT_FILE
# done < <(cut -d: -f1 /etc/passwd)

printf "\n\nUsers Password Expire Policy\n----------------------------------------\n" >> $AUDIT_FILE
printf "User\t Password Change Date\t Password Expire Date\n" >> $AUDIT_FILE
for i in "${all_users[@]}";
do
  USER_EXPIRE_DATE=$(sudo grep infra /etc/shadow | cut -d":" -f 5)
  LAST_PASS_CHANGE=$(sudo grep infra /etc/shadow | cut -d":" -f 3)
  CHANGE_DATE=$(date -d "01/01/1970 +$LAST_PASS_CHANGE days" +%F)
  EXPIRE_DATE=$(date -d "$CHANGE_DATE +$USER_EXPIRE_DATE days" +%F)
  echo -e "$i\t\t $CHANGE_DATE\t\t $EXPIRE_DATE">> $AUDIT_FILE
done

echo -e "\n\nssh file permission\n" >> $AUDIT_FILE
for i in "${all_users[@]}";
do
	FILE_ATTR=$(sudo -H -u $i bash -c 'lsattr ~/.ssh/authorized_keys 2>/dev/null')
	echo -e "$i user SSH Key Permission\n $FILE_ATTR\n" >> $AUDIT_FILE
done
