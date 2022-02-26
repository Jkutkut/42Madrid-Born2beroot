#!/bin/bash
arq=$(
	uname -a # print system information (-a for all).
) # architecture of your operating system and its kernel version.

cpu=$(
	grep "physical id" /proc/cpuinfo | # Get information related to physical CPUs
	uniq | # Remove duplicated lines
	wc -l # Count lines
) # number of physical processors

vcpu=$(
	grep "processor" /proc/cpuinfo | # Get information related to physical CPUs
	uniq | # Remove duplicated lines (optional)
	wc -l # Count lines
)

totalram=$(
	free -m | # Show RAM memory stats (-m to use MB as unit).
	grep Mem | # Only keep memory (remove swap).
	awk '{print $2}' # Print the second element (1 based).
) # The current total RAM on your server.

usedram=$(
	free -m | # Show RAM memory stats (-m to use MB as unit).
	grep Mem | # Only keep memory (remove swap).
	awk '{print $3}' # Print the second element (1 based).
) # The current used RAM on your server.

rampercentage=$(awk '{printf("%.2f"), $1/$2}' <<<""$(($usedram * 100))" $totalram") # Division with 2 decimals

diskusage=$(
	df -hm --total | # Space used in a human readable way (-h), in MB and showing the total sum
	grep total | # Only taking the total line
	awk '{print $3}' # Only take the number
)

totaldisk=$(
	df -hm --total |
	grep total |
	awk '{print $2}'
)

diskpercentage=$(df -h --total | grep total | awk '{print $5}')
cpuload=$(top -bn1 | grep %Cpu\(s\): | awk '{printf("%.1f", $2+$4)}')
lastboot=$(who -b | tr -d ' ' | sed s'/systemboot//')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then echo YES; else echo NO; fi)
tcp=$(ss -s | grep TCP: | awk '{print $4}' | tr -d ',')
users=$(users | wc -w)
ip=$(hostname -I)
macaddress=$(ip a | grep link/ether | tr -d ' ' | sed s'/link\/ether//' | sed s'/brd.*//')
numbersudo=$(grep -a sudo /var/log/auth.log | grep TSID | wc -l)

echo "# Arquitecture: $arq"
echo "# CPU physical: $cpu"
echo "# vCPU: $vcpu"
echo "# Memory Usage: $usedram/${totalram}MB ($rampercentage%)"
echo "# Disk Usage: $diskusage/$totaldisk ($diskpercentage)"
echo "# CPU load: $cpuload%"
echo "Last boot: $lastboot"
echo "# LVM use: $lvm"
echo "# Connection TCP: $tcp"
echo "# User log: $users"
echo "# Network: IP $ip ($macaddress)"
echo "# Sudo: $numbersudo cmd"
