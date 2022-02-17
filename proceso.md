# Born 2 be root

## Install sudo:

Install the sudo command to execute super user commands without being root.

	su -

<br>

	apt install sudo

## Add user to sudo group:
To check if a user is in the sudo group:

	su -

<br>

	usermod -aG sudo your_username


## Notes:
- When the command *su -* is present, the intention is to be executed as root.