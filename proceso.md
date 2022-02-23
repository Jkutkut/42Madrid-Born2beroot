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
			- man:

					sudo apt-get install man -y
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

### SSH Useful commands:

|Name|Command|Description|
|:---:|:---:|:---:|
|Check status ssh|``sudo systemctl status ssh``|Shows the current status of SSH server service.|
|Restart SSH service|``sudo service ssh restart``|Restart the SSH service.|
|Check port settings|``sudo grep Port /etc/ssh/sshd_config``|Allows to see the current configuration of the port settings (NOT THE SERVICE).|

### Configuration:
- [Check server status](#SSH-Useful-commands)
- [Restart SSH service](#SSH-Useful-commands)
- Change default port (22) to 4242:
	- Open with sudo the configuration file.

			sudo vim /etc/ssh/sshd_config
	- Find the line:

			#Port 22
	- Replace it with:

			Port 4242

	- Save and exit (verify the file has been edited correctly).

- Restart server:
	- If you use [Check server status](#SSH-Useful-commands) again, you will see that nothing has changed. That is because the change will not take effect until the service is restarted. Therefore, use [Restart SSH service](#SSH-Useful-commands).
	- If done correctly, it is possible to see in the log of [Check server status](#SSH-Useful-commands) that the server is now listening on 4242 port.
	- Also you can see that the ID has changed as expected.
	- Example:

			$ sudo systemctl status ssh | grep port
			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 22.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 22.
			$ sudo service ssh restart
			$ sudo systemctl status ssh | grep port
			DATE MACHINE_NAME sshd[ID]: Server listening on 0.0.0.0 port 4242.
			DATE MACHINE_NAME sshd[ID]: Server listening on :: port 4242.

## Setup firewall:
### Install UFW (Uncomplicated firewall):
		sudo apt install ufw

### UFW Useful commands:
|Name|Command|Description|
|:---:|:---:|:---:|
|Enable UFW|``sudo ufw enable``|Enables UFW and enables it on system startup.|
|Check UFW status|``sudo ufw status numbered``|Show the current status and rules of UFW. The param *numbered* shows the index of each one to show |
|Allow ssh|``sudo ufw allow ssh``|Allows to use ssh|
|Open port|``sudo ufw allow PORT``|Opens the given port (ei: 4242)|
|Remove port|``sudo ufw delete PORT_ID``|Removes a the given port (the number when executing ``sudo ufw status numbered``)|

### Setup UFW:
- [Enable UFW](#UFW-Useful-commands)
- [Check UFW status](#UFW-Useful-commands)
- [Allow SSH](#UFW-Useful-commands)

		sudo ufw allow ssh
- Configure port rules:
	- Open 4242:

			sudo ufw allow 4242

	- Remove all the other rules. If done correctly, you should have something like this:
	![ufw_result](./res/ufw_result.png)

## Allow SSH connection using Virtualbox:
- Go to VirtualBox-> Choose the VM->Select Settings
- Choose “Network”-> “Adapter 1"->”Advanced”->”Port Forwarding”
- Add a new one with the following values:

	|Name|Protocol|Host IP|Host Port|Guest IP|Guest Port|
	|:---:|:---:|:---:|:---:|:---:|:---:|
	|SSH|TCP||4242||4242|

- For this configuration to be applied, you must [Restart SSH server](#SSH-Useful-commands).

		sudo systemctl restart ssh

- From now own, you can enter the machine from your host machine using:

		ssh USER@127.0.0.1 -p 4242


## Set up password policy:
This step will allow us to enforce some requirements on the passwords generated from now on.
- Install the library to check password quality:

		sudo apt-get install libpam-pwquality

- Change expiration rules:
	- Open the file:

			sudo nano /etc/login.defs

	- Modify the following rules:

			PASS_MAX_DAYS 9999
			PASS_MIN_DAYS 0
			PASS_WARN_AGE 7

	|Command|Explanation|
	|:---:|:---:|
	|```PASS_MAX_DAYS``` N|Maximum life of a single password.|
	|```PASS_MIN_DAYS``` N|Minimum life of a single password (0 to disable).|
	|```PASS_WARN_AGE``` N|Recieve a notification N days before remembering to change it.|

	- In my case, it ended up with:

			PASS_MAX_DAYS 30
			PASS_MIN_DAYS 2
			PASS_WARN_AGE 7

- Change the password quality rules:
	- Open the file:

			sudo nano /etc/pam.d/common-password

	- Find the line:

			password [success=2 default=ignore] pam_unix.so obscure sha512

		- Add ```minlen=10``` at the end:

				password [success=2 default=ignore] pam_unix.so obscure sha512 minlen=10

	|Element|Explanation|
	|:---:|:---:|
	|obscure|Do some tests on the password: Palindrome, case sensitive...|
	|sha512|Use this type of encryption|
	|||
	|||


	- Configure the rest of the settings. Find the line:

			password requisite pam_pwquality.so retry=3

		- Add the following at the end:

				password requisite pam_pwquality.so retry=3 lcredit =-1 ucredit=-1 dcredit=-1 maxrepeat=3 usercheck=0 difok=7 enforce_for_root

	|Element|Explanation|
	|:--:|:--:|
	|```lcredit=```N|Minimum number of *lower-case* characters.|
	|```ucredit=```N|Minimum number of *upper-case* characters.|
	|```dcredit=```N|Minimum number of *digit* characters.|
	|```maxrepeat=```N|Maximun character repetition.|
	|```usercheck=```N|If the password can contain the user name in some form (1: ON, 0: OFF).|
	|```difok=```N|Minimum number of chararters that must be different from the previous password.|
	|```enforce_for_root```|This rules also apply for root users.|

- And that's it! Just reboot the machine to affect the changes.

		sudo reboot

## Notes:
- When the command *su -* is present, the intention is to be executed as root. Therefore, all sections not using this command are supposed to be run without being root.
- When following this guide, please check that the previous step has worked before going to the next.
- When editing a file, the command will use the editor **Vim**. Feel free to use the one you prefer.
- If the following words are present in a command, they would be different depending on the state of the machine:
	- DATE
	- MACHINE_NAME
	- ID
	- PORT
	- USER
	- N