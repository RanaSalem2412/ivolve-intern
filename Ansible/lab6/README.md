Lab 6: Ansible Installation
* Objective: Install and configure Ansible Automation Platform on control nodes, create inventories of a managed host, and then perform ad-hoc commands to check functionality
  ---
  install ansbile:
  ```
  sudo yum install -y ansible
  ```
  Check if the installation was successful:
  ```
  ansible --version
  ```

  Open the hosts list file:
  ```
  sudo vim /etc/ansible/hosts
  ```
  Add the following to the file:
  ```
  [my_servers]
  servera ansible_host=servera ansible_user=student
  serverb ansible_host=serverb ansible_user=student
  ```
  Test that the file was updated successfully:
  ```
  ansible-inventory --list -y
  ```
  If you don't have an SSH key, create one:
  ```
  ssh-keygen -t rsa -b 4096
  ```
  Add the key to ServerA and ServerB:
  ```
  ssh-copy-id student@servera
  ssh-copy-id student@serverb
  ```
  Test the connection via SSH:
  ```
  ssh student@servera
  ssh student@serverb
  ```
  Run ad-hoc commands to test the connection
  ---
  Test connection via Ping:
  ```
  ansible my_servers -m ping
  ```
  To create a /tmp/testfile.txt file on all servers, use:
  ```
  ansible my_servers -m file -a "path=/tmp/testfile.txt state=touch"
  ```
  Verify that the file was created via SSH:
  ```
  ssh student@servera "ls -l /tmp/testfile.txt"
  ssh student@serverb "ls -l /tmp/testfile.txt"
  ```
  Run a shell command To make sure Ansible can run shell commands:
  ```
  ansible my_servers -m shell -a "date"
  ```
  





  










  







  









  
  


