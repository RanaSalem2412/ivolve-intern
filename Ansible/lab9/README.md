# Lab 9: Ansible Roles for Application Deployment
### * Objective: Organize Ansible playbooks using roles. Create an Ansible role for installing Jenkins, docker, openshift CLI 'OC'.
## Objective
#### The objective of this lab is to organize Ansible playbooks using roles. We will create separate roles to install and configure:
##### .Jenkins
##### .Docker
##### .OpenShift CLI (OC)
---
##### Each role will manage the installation of dependencies, configuration, and service management for its respective application.
## Creating Ansible Roles
### To create the necessary roles, use the following commands:
```
ansible-galaxy init roles/jenkins
ansible-galaxy init roles/docker
ansible-galaxy init roles/oc
```
## Role Details
### Jenkins Role (roles/jenkins/tasks/main.yml)
#### Installs required dependencies such as wget, java-17-openjdk, and fontconfig.
#### Adds the Jenkins repository.
#### Installs Jenkins.
#### Ensures the Jenkins service is enabled and started.
### Verifies the installation using:
```
systemctl status jenkins
```
---
### Docker Role (roles/docker/tasks/main.yml)
#### nstalls dependencies like yum-utils, device-mapper-persistent-data, and lvm2.
#### Adds the Docker repository.
#### Installs Docker CE.
#### Starts and enables the Docker service.
### Verifies Docker installation using:
```
docker --version
```
---
### OpenShift CLI Role (roles/oc/tasks/main.yml)
#### Installs dependencies such as wget and tar.
#### Downloads the latest OpenShift CLI tarball.
#### Extracts the CLI into /usr/local/bin/.
### Verifies the installation using:
```
oc version
```
---
## Playbook
### The playbook includes all three roles and applies them to the target host:
```
- name: install Jenkins, Docker, and OpenShift CLI
  hosts: servers
  become: yes
  roles:
    - jenkins
    - docker
    - oc
```
---
## Inventory File 
### An example inventory file:
```
[servers]
servera ansible_host=servera ansible_user=student ansible_ssh_private_key_file=~/.ssh/id_rsa
servera ansible_host=servera ansible_user=student ansible_ssh_private_key_file=~/.ssh/id_rsa
```
































