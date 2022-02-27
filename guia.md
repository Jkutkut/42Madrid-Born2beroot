# Born2beroot:

- Esta guía esta diseñada para 42Cursus-Born2beroot.
- Esta guía supone que ya tienes instalada una máquina virtual debian.

Por favor, lee la sección de [notas](#notas) antes de empezar.

# Configuración:

## Sudo:
Usamos ```sudo``` para ejecutar comandos de superusuario sin ser root. Esto es, en general, más seguro que ser siempre root.

- Instalación de sudo:

		su -
		apt install sudo

- Add user to sudo group:

	Este paso nos hará pertenecer al grupo sudo.

	Este paso nos permitirá ejecutar commandos con SSH en el futuro cercano.

		su -
		usermod -aG sudo USER

Si hecho de manera correcta, deberíamos ver que el usuario pertenece al grupo con el comando:

	getent group sudo

### Dar al usuario privilegios de superusuario:

- Abre el archivo ```/etc/sudoers``` y agrega la siguiente línea:

		su -
		visudo

- Añade esta línea si no está ya:

		%sudo	ALL=(ALL) ALL
	
	(un buen sitio es justo debajo de esta:)

		root	ALL=(ALL) ALL

- Guarda y sal del archivo. Si está hecho de manera correcta, puedes logearte de nuevo con tu cuenta para verificar si ha funcionado.

- Por ejemplo, ahora deberías ser capaz de ejecutar este comando sin ser root:

		apt update # Este no funcionará
		sudo apt update

## Instalación de herramientas:
Necesitamos instalar algunas herramientas que son esenciales:

### Actualizando los paquetes/sistema actual:

	sudo apt update && sudo apt upgrade -y

### Instalar las herramientas:
- git:

		sudo apt install git -y

- wget o curl:
	- Ambas herramientas nos permiten descargar archivos de internet a través de su URL.
	- No son 100% necesarias para el proyecto pero son útiles.
	- En mi caso, he usado wget usando:

		sudo apt install wget -y

- Herramientas de personalización:
	- Este paso es opcional.
	- En mi caso, para trabajar de una manera más cómoda y rápida:
		- He instalado:
			- man:

					sudo apt install man -y
			- vim:

					sudo apt install vim -y
			- zsh:

					sudo apt install zsh -y

			- [Oh my zsh](https://ohmyz.sh/)
		- He editado tanto **~/.zshrc** y **~/.vimrc** con la configuración básica que necesito para trabajar de una manera rápida e inteligente.
		- Ten en cuenta que estas herramientas son ligeras y fáciles de quitar si fuera necesario, con lo que puedes quitarlo en cualquier momento.
	- Recuerda que instalar una interfaz gráfica está prohibido.


## Configurando el servicio SSH:
Este paso nos permitirá conectarnos a la máquina virtual a través de un terminal de nuestro ordenador. Esto es muy bueno para poder copiar y pegar contenido entre ambas máquinas.

### Instalación de SSH:
		sudo apt update && sudo apt install openssh-server -y

### Comandos útiles de SSH:

|Nombre|Comando|Descripción|
|---:|:---:|:---|
|Ver estado ssh|``sudo systemctl status ssh``|Muestra el estado actual del servicio SSH.|
|Reiniciar servicio SSH|``sudo service ssh restart``|Reinicia el servicio SSH.|
|Check port settings|``sudo grep Port /etc/ssh/sshd_config``|Nos permite ver los puertos configurados en la configuración (NO DEL SERVICIO).|

### Configuración:
- [Ver estado ssh](#comandos-útiles-de-ssh)
- [Reinicia el servicio SSH](#comandos-útiles-de-ssh)
- Cambia el puerto por defecto (22) al 4242:
	- Abre con sudo el archivo de configuración:

		sudo vim /etc/ssh/sshd_config
	- Encuentra la línea:

			#Port 22
	- Cambia el valor por:

			Port 4242

	- Guarda y sal del archivo (verifica que se ha editado correctamente).

- Reinicia el servicio:
	- Si usas [Ver estado ssh](#comandos-útiles-de-ssh) otra vez, verás que nada ha cambiado. Esto es porque los cambios no tendrán efecto hasta que el servicio se reinicie. Por tanto, [Reinicia el servicio SSH](#comandos-útiles-de-ssh).
	- Si todo ha ido bien, es posible ver en el resultado de [Ver estado ssh](#comandos-útiles-de-ssh) que el servidor está ahora escuchando por el puerto 4242.
	- También puedes ver que el ID ha cambiado de manera esperada.
	- Ejemplo:

			sudo systemctl status ssh | grep port
		<br>

			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 22.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 22.
		<br>

			sudo service ssh restart
			sudo systemctl status ssh | grep port
		<br>

			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 4242.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 4242.

## Configuración del firewall:
### Instalación del firewall:
		sudo apt update && sudo apt install ufw -y

### Comandos útiles de UFW:
|Nombre|Comando|Descripción|
|---:|:---:|:---|
|Activar UFW|``sudo ufw enable``|Activa UFW y lo configura para que se active cada vez que se inicie el servidor.|
|Ver estado UFW|``sudo ufw status numbered``|Muestra el estado actual y las reglas de UFW. El parámetro *numbered* nos muestra el índice de cada una (PORT_ID)|
|Permite SSH|``sudo ufw allow ssh``|Permite el uso de SSH|
|Abre puerto|``sudo ufw allow`` PORT|Abre el puerto dado (ej: 4242)|
|Quita puerto|``sudo ufw delete`` PORT_ID|Quita el puerto seleccionado (usando el índice que nos da el comando ``sudo ufw status numbered``)|

### Configuración UFW:
- [Activar UFW](#comandos-útiles-de-ufw)
- [Ver estado UFW](#comandos-útiles-de-ufw)
- [Permite SSH](#comandos-útiles-de-ufw)

		sudo ufw allow ssh
- Configura las reglas de los puertos:
	- Abre el puerto 4242:

		sudo ufw allow 4242

	- Elimina todos los otros puertos. Si hecho correctamente, debería quedar:
	![ufw_result](./res/ufw_result.png)

## Permitir la conexión SSH usando Virtualbox:



















# Notes:
- Cuando el comando *su -* es mostrado, la intención es que se ejecute siendo root. Por tanto, todas las secciones que no usen ese comando están pensadas para ser ejecutadas no siendo root (```USER```).
- Antes the avanzar a la siguiente sección, verifica que lo hecho hasta ahora ha funcionado correctamente. El orden elegido con un motivo específico.
- Cuando sea necesario editar un archivo, el comando utilizado será **Vim**. Siéntete libre de usar el que prefieras.
- Si en algún momento encuentra alguna de estas palabras, estas dependerán de su máquina y deberán ser cambiadas por la que corresponda.
	- DATE
	- MACHINE_NAME
	- ID
	- PORT
	- USER
	- N
	- GROUP
	- MESSAGE
	- FILE