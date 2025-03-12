# Lab 7: Ansible Playbooks for Web Server Configuration
### * Objective: Write an Ansible playbook to automate the configuration of a web server.
## Overview
#### his Ansible Playbook automates the setup and configuration of an Apache Web Server on ServerA. It installs Apache, starts the service, configures a custom index page, and ensures the firewall allows HTTP traffic
---
## Prerequisites
### Before running the playbook, ensure the following:
#### 1-Ansible is installed on the control node (Workstation).
#### 2-SSH access is configured from Workstation to ServerA
#### 3-Inventory file is updated with ServerA details
---
##  Inventory Setup
#### Edit the Ansible inventory file (/etc/ansible/hosts) and add ServerA:
```
[web_servers]
servera ansible_host=servera ansible_user=student ansible_ssh_pass=student
```
---
##  Playbook: webserver.yml
```
---
- name: Configure Apache Web Server
  hosts: web_servers
  become: yes
  tasks:
    - name: Install Apache
      yum:
        name: httpd
        state: present

    - name: Start and enable Apache service
      systemd:
        name: httpd
        state: started
        enabled: yes

    - name: Create a custom index.html
      copy:
        content: "<h1>Welcome to ServerA Web Server</h1>"
        dest: /var/www/html/index.html
        mode: '0644'

    - name: Open HTTP port in firewall
      firewalld:
        service: http
        permanent: yes
        state: enabled
      notify: Restart firewalld

  handlers:
    - name: Restart firewalld
      systemd:
        name: firewalld
        state: restarted
```
---
## Running the Playbook
### Execute the playbook using the following command:
```
ansible-playbook webserver.yml --ask-pass --ask-become-pass
```
#### .--ask-pass: Prompts for SSH password (if not using keys).
#### .--ask-become-pass: Prompts for sudo password
---
## Verification
### 1.Check Apache Service on ServerA:
```
sudo systemctl status httpd
```
####Ensure the status is active (running)
### 2.Test Locally on ServerA:
```
curl http://localhost
```
#### Expected output:
##### Welcome to ServerA Web Server
### 3.Test from Workstation:
```
curl http://172.25.250.10
```
 



















