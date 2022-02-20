# Born 2 be root

## Install sudo:

Install the sudo command to execute super user commands without being root.

	su -

<br>

	apt install sudo

## Add user to sudo group:
To check if a user is in the sudo group:

	su -

<br>

	usermod -aG sudo your_username


If done correctly, using this command we should see the user:

	getent group sudo

## Give user su privileges

Open the sudoers file:

	su -

<br>

	sudo visudo

Add this line:

	username	ALL=(ALL) ALL

(a nice place to place it is just bellow this one)

	root	ALL=(ALL) ALL

Save and exit the file. If done correctly, you can log back to your login account to check if it works.

For example, now you should be able to execute this command without being root:

	sudo apt update


## Notes:
- When the command *su -* is present, the intention is to be executed as root.