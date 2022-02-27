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