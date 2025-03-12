# Lab 12: Launching an EC2 Instance
## * Objective: Create a VPC with public and private subnets and 1 EC2 in each subnet, configure private EC2 security group to only allow inbound SSH from public EC2 IP, SSH to the private instance using the public bastion host
## Prerequisites
### Before starting, ensure you have the following:
#### An AWS account
#### AWS Management Console access
#### MobaXterm (optional)
---
## Step 1: Create a VPC
### 1-Navigate to VPC Dashboard in AWS.
### 2-Click Create VPC and enter:
#### Name: Lab12-VPC
#### Pv4 CIDR: 10.0.0.0/16
### 3-Click Create VPC.
---
## Step 2: Create Subnets
### 1-Go to Subnets and click Create Subnet.
### 2-Create a Public Subnet:
#### Name: Public-Subnet
#### VPC: Lab12-VPC
#### CIDR: 10.0.1.0/24
### 3-Create a Private Subnet:
#### Name: Private-Subnet
#### VPC: Lab12-VPC
#### CIDR: 10.0.2.0/24
### 4-create subnet
---
## Step 3: Enable Auto-Assign Public IP for Public Subnet
### 1-Select Public-Subnet.
### 2-Click Actions > Edit Subnet Settings.
### 3-Enable Auto-assign public IPv4.
### 4-Click Save.
---
## Step 4: Create an Internet Gateway (IGW)
### 1-Go to Internet Gateways and click Create Internet Gateway.
### 2-Enter Lab12-IGW as the name.
### 3-Click Create.
### 4-Attach it to Lab12-VPC:
#### Select the IGW.
#### Click Actions > Attach to VPC.
#### Choose Lab12-VPC and click Attach.
---
## Step 5: Update Route Table for Public Subnet
### 1-Go to Route Tables.
### 2-Select the route table associated with Lab12-VPC
### 3-Click Edit Routes > Add Route:
#### Destination: 0.0.0.0/0
#### Target: Lab12-IGW
### 4-Click Save Changes.
### 5-Associate it with Public-Subnet:
#### Click Subnet Associations > Edit Subnet Associations.
#### Select Public-Subnet.
#### Click Save.
---
## Step 6: Create Security Groups
### A. Security Group for Bastion Host
#### 1-Go to Security Groups and click Create Security Group.
#### 2-Set:
##### Name: Bastion-SG
##### VPC: Lab12-VPC
#### 3-Add Inbound Rule:
##### Type: SSH
##### Source: 0.0.0.0/0
#### 4-Click Create Security Group.
### B. Security Group for Private EC2
#### 1-Click Create Security Group again.
#### 2-Set:
##### Name: Private-EC2-SG
##### VPC: Lab12-VPC
#### 3-Add Inbound Rule:
##### Type: SSH
##### Source: Bastion-SG
#### 4-Click Create Security Group.
---
## Step 7: Launch EC2 Instances
### A. Launch Bastion Host in Public Subnet
#### 1-Go to EC2 > Instances > Launch Instance.
#### 2-Select Amazon Linux 2 AMI.
#### 3-Choose t2.micro instance type.
#### 4-Configure:
##### Network: Lab12-VPC
##### Subnet: Public-Subnet
##### Auto-assign Public IP: Enable
##### Security Group: Bastion-SG
#### 5-Select Key Pair (Create).
#### 6-Click Launch Instance.
### B. Launch Private EC2 in Private Subnet
#### 1-Repeat the above steps, but configure:
##### Network: Lab12-VPC
##### Subnet: Private-Subnet
##### Auto-assign Public IP: Disable
##### Security Group: Private-EC2-SG
---
## Step 8: Connect to Private EC2 via Bastion Host
### A. Connect to Bastion Host (Windows using MobaXterm.)
#### 1-Convert Lab12-KeyPair.pem to .ppk using PuTTYgen.
#### 2-Open MobaXterm and select type of session (ssh) .
#### 3-enter Bastion Host Public IP under Host Name and enter (ec2-user)
#### 4-Browse and select the .ppk file.
#### 5-Click Open to connect.
### B. SSH into Private EC2 from Bastion
#### 1-Connect to Bastion Host.
#### 2-Move the key
#### 3-Connect to Private EC2:
```
ssh -i ~/.ssh/Lab12-KeyPair.pem ec2-user@<Private_EC2_IP>
```







