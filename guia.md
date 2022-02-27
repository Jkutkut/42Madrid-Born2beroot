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