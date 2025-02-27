Lab 5: SSH Configurations
Objective: Generate public and private keys and enable SSH from your machine to another VM using the key. Configure SSH to just run 'ssh ivolve' without specify username, IP and key in the command
---
Check if you already have an SSH key:
```
ls -l ~/.ssh/id_rsa
```
If it does not exist → create a new key using the following command:
```
ssh-keygen -t rsa -b 4096
```
Command output:
You will be asked to enter the file name → press Enter to use the default name.
You will be asked to enter Passphrase → press Enter without entering anything.
Two keys will be generated:
Private key: /home/student/.ssh/id_rsa
Public key: /home/student/.ssh/id_rsa.pub


Now, add the public key to ServerA so you can connect without a password:
```
ssh-copy-id student@servera
```
Connect to ServerA without password:
```
ssh student@servera
```
If you log in without asking for a password, the step was completed successfully.


On Workstation, open the settings file:
```
vim ~/.ssh/config
```
Then add the following lines:
```
Host ivolve
    HostName servera
    User student
    IdentityFile ~/.ssh/id_rsa
```
Try running:
```
ssh ivolve
```











