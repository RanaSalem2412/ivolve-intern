# Lab 13: Create AWS Load Balancer
## * Objective: create VPC with 2 subnets, launch 2 EC2s with nginx and apache installed, and create and configure a Load Balancer to access the 2 Web servers
## Overview
#### This guide walks through setting up a VPC, launching EC2 instances, installing Nginx and Apache, and configuring an Application Load Balancer (ALB) to distribute traffic between the two servers.
---
## 1-Create a VPC
### 1-Navigate to the VPC Dashboard in AWS.
### 2-Click Create VPC.
### 3-Enter the following details:
#### - Name: Lab13-VPC
#### -IPv4 CIDR: 10.0.0.0/16
### 4-Click Create VPC.
---
## 2-Create Subnets
### 1-Go to Subnets > Click Create Subnet.
### 2-Select Lab13-VPC and create two subnets:
#### -Public-Subnet-1 (10.0.1.0/24) in us-east-1a
#### -Public-Subnet-2 (10.0.2.0/24) in us-east-1b
---
## 3-Create an Internet Gateway
### 1-Navigate to Internet Gateways > Click Create Internet Gateway.
### 2-Name it Lab13-IGW.
### 3-Attach it to Lab13-VPC.
---
## 4-Update the Route Table
### 1-Go to Route Tables and find the one associated with Lab13-VPC.
### 2-Add a new route:
#### -Destination: 0.0.0.0/0
#### -Target: Lab13-IGW
---
## 5-Launch EC2 Instances
### 1-Launch two EC2 instances:
#### -Instance 1: Apache-Server
#### -Instance 2: Nginx-Server
### 2-Assign them to the Public Subnets.
### 3-Attach a Security Group allowing inbound SSH (22) and HTTP (80).
---
## 6-Install Web Servers
### nstall Apache (on Apache-Server):
```
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
echo "Welcome to Apache Server" | sudo tee /var/www/html/index.html
```
### Install Nginx (on Nginx-Server):
```
sudo amazon-linux-extras enable nginx1
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
echo "Welcome to Nginx Server" | sudo tee /usr/share/nginx/html/index.html
```
---
## 7-Create an Application Load Balancer (ALB)
### 1-Navigate to EC2 > Load Balancers.
### 2-Click Create Load Balancer.
### 3-Choose Application Load Balancer (ALB).
### 4-Enter the details:
#### -Name: Lab13-ALB
#### -Scheme: Internet-facing
#### -VPC: Lab13-VPC
#### -Subnets: Public-Subnet-1, Public-Subnet-2
---
## 8-Create a Security Group for ALB
### 1-Navigate to EC2 > Security Groups.
### 2-Click Create Security Group.
### 3-Configure as follows:
#### -Name: Lab13-ALB-SG
#### -Inbound Rule:
##### .Type: HTTP
##### .Protocol: TCP
##### .Port: 80
##### Source: 0.0.0.0/0
### 4-Attach this Security Group to Lab13-ALB.
---
## 9-Create a Target Group
### 1-Go to EC2 > Target Groups.
### 2-Click Create Target Group.
### 3-Configure as follows:
#### -Name: Lab13-TG
#### -Target Type: Instance
#### -Protocol: HTTP
#### -Port: 80
#### -VPC: Lab13-VPC
### 4-Click Next and register both EC2 instances (Apache-Server & Nginx-Server).
---
## 10-Associate Target Group with ALB
### 1-Go to EC2 > Load Balancers.
### 2-Select Lab13-ALB and navigate to Listeners.
### 3-Click View/Edit Rules and set Forward to Lab13-TG.
### 4-Save the changes.
---
## Final Test
### Open the ALB DNS in your browser:
```
http://Lab13-ALB-xxxxxxxx.elb.amazonaws.com
```
### Refresh multiple times to see requests being distributed between Apache and Nginx.















