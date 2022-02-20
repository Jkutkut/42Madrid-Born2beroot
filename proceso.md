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

	sudo apt update -y && sudo apt upgrade -y

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


## 

## Notes:
- When the command *su -* is present, the intention is to be executed as root. Therefore, all sections not using this command are supposed to be run without being root.
- When following this guide, please check that the previous step has worked before going to the next.