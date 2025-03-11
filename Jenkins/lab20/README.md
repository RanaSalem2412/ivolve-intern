# Lab 20: Jenkins Installation
##### * Install Jenkins
##### * OPTION 1: Install and configure Jenkins as a service
##### * OPTION 2: Install and Configure Jenkins as a container

---
# Jenkins Installation in Docker (Windows)

### Prerequisites
---
##### Windows 10/11 with Docker Desktop installed and running.

##### Ensure Docker is using Linux containers.

---
## Step 1: Install Docker
##### Download Docker Desktop from Docker official website.

##### Install and restart your computer.

##### Open PowerShell and verify installation:
```
docker --version
```
---
## Step 2: Run Jenkins as a Docker Container
#### 1-Open PowerShell and execute:
```
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```
-d → Run container in detached mode.

--name jenkins → Assigns a name to the container.

-p 8080:8080 → Maps Jenkins UI port.

-p 50000:50000 → Maps Jenkins agent communication port.

-v jenkins_home:/var/jenkins_home → Persistent Jenkins data storage.

#### 2-Check if the container is running:
```
docker ps
```
---
## Step 3: Access Jenkins
#### 1-Open a browser and go to:
```
http://localhost:8080
```
#### 2-Retrieve the initial admin password:
```
docker exec -it jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```
#### 3-Copy and paste the password into the Jenkins setup page
#### 4-Select Install suggested plugins
#### 5-Create an Admin user with a valid username

















