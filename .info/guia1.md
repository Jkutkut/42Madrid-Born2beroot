#!/bin/bash
arq=$(uname -a)
cpu=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)
vcpu=$(grep "processor" /proc/cpuinfo | wc -l)
totalmem=$(free -m | grep Mem | awk '{print $2}')
usedmem=$(free -m | grep Mem | awk '{print $3}')
percentage=$(awk '{printf("%.2f"), $1/$2}' <<<""$(($usedmem*100))" $totalmem")
diskusage=$(df -hm --total | grep total | awk '{print $3}')
totaldisk=$(df -h --total | grep total | awk '{print $2}')
diskpercentage=$(df -h --total | grep total | awk '{print $5}')
cpuload=$(top -bn1 | grep %Cpu\(s\): | awk '{printf("%.1f", $2+$4)}')
lastboot=$(who -b | tr -d ' ' | sed s'/systemboot//')
lvm=$(if [ $(lsblk | grep lvm | wc -l) -gt 0 ]; then echo YES; else echo NO; fi)
tcp=$(ss -s | grep TCP: | awk '{print $4}' | tr -d ',')
users=$(users | wc -w)
ip=$(hostname -I)
macaddress=$(ip a | grep link/ether | tr -d ' ' | sed s'/link\/ether//' | sed s'/brd.*//')
numbersudo=$(grep -a sudo /var/log/auth.log | grep TSID | wc -l)
echo '#Arquitecture: '$arq
echo '#CPU physical: '$cpu
echo '#vCPU: '$vcpu
echo '#Memory Usage: '$usedmem'/'$totalmem'MB ('$percentage'%)'
echo '#Disk Usage: '$diskusage'/'$totaldisk' ('$diskpercentage')'
echo '#CPU load: '$cpuload'%'
echo 'Last boot: '$lastboot
echo '#LVM use: '$lvm
echo '#Connection TCP: '$tcp
echo '#User log: '$users
echo '#Network: IP '$ip' ('$macaddress')'
echo '#Sudo: '$numbersudo' cmd'
