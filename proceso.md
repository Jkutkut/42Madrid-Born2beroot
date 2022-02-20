# Born 2 be root

- This guide was made for the project 42Cursus-Born2beroot.
- This guide is designed for those who already created a debian-virtual machine.

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


## Installing tools:
We need to install some essential tools:

### Updating and upgrading the current packages:

	sudo apt update && sudo apt upgrade -y

### Installing the tools:
- git:

		sudo apt-get install git -y

- wget or curl:
	- Both of these tools allows to download content from a given URL.
	- They are not 100% essential but they are just convenient.
	- In my case, i've downloaded wget using:

		sudo apt-get install wget -y

- Personalization tools:
	- This step is optional.
	- In my case, to work faster:
		- I've installed:
			- vim

					sudo apt-get install vim -y
			- zsh

					sudo apt-get install zsh -y

			- [Oh my zsh](https://ohmyz.sh/)
		- I've edited both **~/.zshrc** and **~/.vimrc** with the basic things I need to work smarter and faster.
		- Also keep in mind that these tools are light weight and easy to remove if needed, so you can remove them any time.
	- Remember that installing a graphic interface is forbidden.


## Setting up SSH service:
### Installing SSH:
		sudo apt-get update && sudo apt-get install openssh-server -y

### Useful commands:

|Name|Command|Description|
|:---:|:---:|:---:|
|Check status ssh|``sudo systemctl status ssh``|Shows the current status of SSH server service.|
|Restart SSH service|``sudo service ssh restart``|Restart the SSH service.|
|Check port settings|``sudo grep Port /etc/ssh/sshd_config``|Allows to see the current configuration of the port settings (NOT THE SERVICE).|

### Configuration:
- [Check server status](#Useful-commands)
- [Restart SSH service](#Useful-commands)
- Change default port (22) to 4242:
	- Open with sudo the configuration file.

			sudo vim /etc/ssh/sshd_config
	- Find the line:

			#Port 22
	- Replace it with:

			Port 4242

	- Save and exit (verify the file has been edited correctly).

- Restart server:
	- If you use [Check server status](#Useful-commands) again, you will see that nothing has changed. That is because the change will not take effect until the service is restarted. Therefore, use [Restart SSH service](#Useful-commands).
	- If done correctly, it is possible to see in the log of [Check server status](#Useful-commands) that the server is now listening on 4242 port.
	- Also you can see that the ID has changed as expected.
	- Example:

			$ sudo systemctl status ssh | grep port
			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 22.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 22.
			$ sudo service ssh restart
			$ sudo systemctl status ssh | grep port
			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 4242.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 4242.




## Notes:
- When the command *su -* is present, the intention is to be executed as root. Therefore, all sections not using this command are supposed to be run without being root.
- When following this guide, please check that the previous step has worked before going to the next.
- When editing a file, the command will use the editor **Vim**. Feel free to use the one you prefer.
- If the following words are present in a command, they would be different depending on the state of the machine:
	- DATE
	- MACHINE_NAME
	- ID