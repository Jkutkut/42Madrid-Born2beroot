# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jre-gonz <jre-gonz@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/02/27 17:15:18 by jre-gonz          #+#    #+#              #
#    Updated: 2022/02/27 17:15:19 by jre-gonz         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

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
) # number of virtual processors

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

rampercentage=$(printf "%.2f" $(( $usedram * 100 / $totalram ))) # Division with 2 decimals

diskusage=$(
	df -hm --total | # Space used in a human readable way (-h), in MB and showing the total sum
	grep total | # Only taking the total line
	awk '{print $3}' # Only take the disk usage number
) # The current disk usage on your server.

totaldisk=$(
	df -hm --total | # Show space used in a human readable way (-h), in MB and showing the total sum
	grep total | # Only taking the total line
	awk '{print $2}' # Only take the total disk space number
) # The current total disk space on your server.

diskpercentage=$(
	df -h --total | # Show space used in a human readable way (-h) and showing the total sum
	grep total | # Only taking the total line
	awk '{print $5}' # Only take the disk usage percentage
) # The current disk usage percentage on your server.

cpuload=$(
	top -bn1 | # Show top stat in batch mode (-b, useful to mix with other commands) only one time (-n1)
	grep %Cpu\(s\): | # Get the line starting with %Cpu(s):
	awk '{printf("%.2f", $2+$4)}' # Add the numbers (two decimal)
) # The current CPU load on your server.

lastboot=$(
	who -b | # Show time of last boot
	sed 's/ *system boot//' # Only keep the date-time
) # Get the datetime of the last boot


if [ $(lsblk| grep lvm | wc -l) -gt 0 ]; then
	# If they are any lines in the partitions command with 'lvm', lvm.
	lvm="YES";
else
	lvm="NO"
fi # Determine if LVM is active or not

tcp=$(
	ss -s | # Using -s to sum the data
	grep TCP: | # Taking only the line starting with TCP:
	awk '{print $4}' | # Get the 4º element (1 based)(one element end on a space).
	tr -d ',' # Remove comma
)

users=$(
	users | # Show the active connections
	wc -w # Count words (connections)
) # Count number of active connections

ip=$(hostname -I) # Show the IP

macaddress=$(
	ip a | # Get the data
	grep link/ether | # Get the line with 'link/ether'
	tr -d ' ' | # Remove the spaces
	sed s'/link\/ether//' | # Also remove link/ether
	sed s'/brd.*//' # and brd and all the following text
) # Get the IPv4 and MAC address

numbersudo=$(
	grep -a sudo /var/log/auth.log | # Open the sudo log file
	grep TSID | # Get the lines with TSID
	wc -l # Count the lines
) # Number of commands executed with sudo


# Use wall instead of echo to show the message on all screens
wall "# Arquitecture: $arq
# CPU physical: $cpu
# vCPU: $vcpu
# Memory Usage: $usedram/${totalram}MB ($rampercentage%)
# Disk Usage: $diskusage/$totaldisk ($diskpercentage)
# CPU load: $cpuload%
Last boot: $lastboot
# LVM use: $lvm
# Connection TCP: $tcp
# User log: $users
# Network: IP $ip ($macaddress)
# Sudo: $numbersudo cmd"
