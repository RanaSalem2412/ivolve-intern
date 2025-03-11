# Lab 21: Role-based Authorization
##### * Create user1 and user2.
##### * Assign admin role for user1 & read-only role for user2.
--- 
## Overview
###### This guide explains how to configure and assign roles using the Jenkins Role Strategy Plugin to control user permissions effectively.
---
## Prerequisites
##### Jenkins is installed and running.
##### The Role Strategy Plugin is installed.
##### You have administrative access to Jenkins.
---
## Steps to Manage Roles
### 1-Enable Role-Based Authorization
##### 1.Go to Manage Jenkins > Configure Global Security
##### 2.Under Authorization, select Role-Based Strategy.
##### 3.Click Save.
### 2-Define Roles
##### 1.Navigate to Manage Jenkins > Manage and Assign Roles > Manage Roles
##### 2.Under Global Roles, enter the role name in the Role to add field and click Add.
##### 3.Grant the necessary permissions:
  ###### . For an administrator, enable Administer (this includes all permissions).
  ###### . For custom roles, manually select required permissions.

##### 4.Click Save.
### 3-Assign Roles to Users
##### 1.Navigate to Manage Jenkins > Manage and Assign Roles > Assign Roles.
##### 2.Under Global Roles, add the username under the required role
##### 3.Click Save
---
## Verification
#### .Try logging in with an assigned user to check if permissions are working correctly.
#### .Adjust role settings if needed and reassign roles.
---
## Conclusion
### Using Role Strategy Plugin, you can effectively manage access control in Jenkins, ensuring security and organization-wide consistency.





  




