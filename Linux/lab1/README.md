Lab 1: User and Group Management
• Objective: Create a new user, assign it to a specific group, and configure permissions to allow the user to install a web server with elevated privileges using sudo:
---

Create the group:
```
sudo groupadd ivolve
```
To create the user and add him to the ivolve group:
```
sudo useradd -m -G ivolve -s /bin/bash ranasalem
```
Set a password for user ranasalem:
```
sudo passwd ranasalem
```
Open sudoers file using visudo:
```
sudo visudo
```
add this line:
```
ranasalem ALL=(ALL) NOPASSWD: /usr/bin/yum install nginx, /usr/bin/systemctl restart nginx
```

switch to user ranasalem:

```
su - ranasalem
```
install nginx without ask about password:

```
sudo yum install nginx
```

Run any other command with sudo and will ask aout password:

```
sudo ls /root
```





















