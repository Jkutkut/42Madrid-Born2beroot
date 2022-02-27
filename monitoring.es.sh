# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    monitoring.es.sh                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: jre-gonz <jre-gonz@student.42madrid.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/02/27 17:15:13 by jre-gonz          #+#    #+#              #
#    Updated: 2022/02/27 17:15:14 by jre-gonz         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

#!/bin/bash

arq=$(
	uname -a # Imprime la información del sistema (-a para imprimir todo).
) # Arquitectura de del sistema operativo y la versión del kernel.

cpu=$(
	grep "physical id" /proc/cpuinfo | # Obtén la información relacionada con las CPUs físicas.
	uniq | # Elimina líneas duplicadas
	wc -l # Cuenta líneas
) # Número de CPUs físiscas

vcpu=$(
	grep "processor" /proc/cpuinfo | # Obtén la información relacionada con las CPUs físicas
	uniq | # Elimina líneas duplicadas (opcional)
	wc -l # Cuenta líneas
) # Número de CPUs virtuales

totalram=$(
	free -m | # Muestra las estadísticas RAM (-m para usar MB)
	grep Mem | # Elimina Swap
	awk '{print $2}' # Usa sólo el segundo elemento
) # La cantidad total de RAM del servidor

usedram=$(
	free -m | # Muestra las estadísticas RAM (-m para usar MB)
	grep Mem | # Elimina Swap
	awk '{print $3}' # Usa sólo el segundo elemento
) # La cantidad de RAM usada por el servidor

rampercentage=$(printf "%.2f" $(( $usedram * 100 / $totalram ))) # Divide con dos decimales

diskusage=$(
	df -hm --total | # Espacio ocupado en formato humano (-h), en MB y mostrando la suma total
	grep total | # Sólo mantén la línea con el total
	awk '{print $3}' # Sólo consigue la memoria usada
) # La memoria usada por el servidor

totaldisk=$(
	df -hm --total | # Espacio ocupado en formato humano (-h), en MB y mostrando la suma total
	grep total | # Sólo mantén la línea con el total
	awk '{print $2}' # Sólo queremos el espacio total del servidor
) # El espacio total del disco del servidor

diskpercentage=$(
	df -h --total | # Espacio ocupado en formato humano (-h), en MB y mostrando la suma total
	grep total | # Sólo mantén la línea con el total
	awk '{print $5}' # Sólo selecciona el porcentaje del disco usado
) # El porcentaje del disco usado por el servidor

cpuload=$(
	top -bn1 | # Muestra las estadísticas de top en modo 'batch' (-b, útil para usarlo con otros commandos después) una sóla vez (-n1)
	grep %Cpu\(s\): | # Obtén la línea que empieza por %Cpu(s):
	awk '{printf("%.2f", $2+$4)}' # Suma con dos decimales
) # La carga total de CPU en el servidor

lastboot=$(
	who -b | # Muestra la fecha del último inicio
	sed 's/ *system boot//' # Sólo usa la fecha y hora
) # La fecha y hora del último inicio de sesión


if [ $(lsblk| grep lvm | wc -l) -gt 0 ]; then
	# Si hay líneas con 'lvm' en la lista de particiones, lvm
	lvm="YES";
else
	lvm="NO"
fi # Determina si es LVM

tcp=$(
	ss -s | # Usando -s para sumar los datos
	grep TCP: | # Usando sólo la línea que empieza con TCP:
	awk '{print $4}' | # Queremos sólo el 4º elemento (un elemento termina con un espacio)
	tr -d ',' # Borra comma
)

users=$(
	users | # Muestra las conexiones activas
	wc -w # Cuenta palabras (conexiones)
) # Cuenta el número de conexiones

ip=$(hostname -I) # Muestra la IP

macaddress=$(
	ip a | # Obtén los datos
	grep link/ether | # Usa sólo la que tiene 'link/ether'
	tr -d ' ' | # Quita espacios
	sed s'/link\/ether//' | # También quita link/ether
	sed s'/brd.*//' # y brd con todo el texto que le sigue
) # Obtén la IPv4 y la direción MAC

numbersudo=$(
	grep -a sudo /var/log/auth.log | # Abre el archivo de logs
	grep TSID | # Obtén las líneas con TSID
	wc -l # Cuenta las líneas
) # Cuenta el número de comandos ejecutados con sudo


# Usa wall en vez de echo para mostrar el mensaje en todas las terminales
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
