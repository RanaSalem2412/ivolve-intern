Lab 3: Shell Scripting Basics
. Objective: Create a shell script that would ping every single server in the
172.16.17.x subnet where x is a number between 0 and 255. If a ping succeeds,
statement "Server 172.16.17.x is up and running" will be displayed. Otherwise,
if a ping fails, statement "Server 172.16.17.x is unreachable" will be displayed.   
---

To know the network:
```
ip a
```
Try manually pinging any address on the network to see if there is a device connected:
```
ping -c 3 172.25.250.11
```
create script:
```
vim ping_servers.sh
```
After writing the code, save the file and give it permission to run:
```
chmod +x ping_servers.sh
```
run script:
```
./ping_servers.sh
```






