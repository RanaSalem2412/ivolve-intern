# Lab 22: Jenkins Pipeline for Application Deployment
### * Clone Dockerfile from: https://github.com/IbrahimAdell/App1.git
### * Create a pipeline that automates the following processes:
### 1. Build Docker image from Dockerfile in GitHub.
### 2. Push image to Docker hub.
### 3. Delete image locally.
### 4. Edit new image in deplovment.vaml file.
### 5. Deploy to k8s.
### * Set pipeline post action (always, success, failure)
---
## Overview
#### In this lab, we set up a Jenkins pipeline to automate the process of building a Docker image from a Dockerfile, pushing it to Docker Hub, updating the Kubernetes deployment file, and deploying the application to Kubernetes. The task was divided into multiple stages in the Jenkins pipeline, with the goal of automating the CI/CD process for application deployment.
---
## Infrastructure Setup
### EC2 1 (Jenkins):
#### Installed Jenkins, kubectl, and Docker.
#### This EC2 instance is responsible for running Jenkins jobs and managing Docker containers.
### EC2 2 (Minikube):
#### Installed Minikube, Docker, and other required tools for Minikube.
#### This EC2 instance runs Minikube as a local Kubernetes cluster for testing deployments.
### Both EC2 instances are located in the same VPC and subnet, with public IPs for external acces
 ---
## Plugins Installed in Jenkins
### 1-Pipeline: AWS Steps
### 2-Kubernetes CLI Plugin
### 3-Docker Pipeline Plugin
---
## Jenkins Credentials Configuration
### Docker Hub Credentials:
#### Go to Manage Jenkins ➝ Manage Credentials.
#### Add new credentials for Docker Hub:
#### Kind: Username with password
#### Username: Docker Hub Username
#### Password: Docker Hub Password
#### ID: docker-hub
#### Description: Docker Hub Credentials
## Kubeconfig Credentials:
##### Download the Kubernetes config file on local host:
```
scp -i ~/Downloads/keypair_lab22.pem ec2-user@44.212.32.219:/home/ec2-user/kubeconfig.yaml C:/Users/ascom/Desktop/
```
#### Upload this file to Jenkins as a secret file:
#### Kind: Secret file
#### File: Upload the config file
#### ID: kubeconfigg
#### Description: Kubernetes Config
## File Copy
### Copied the deployment.yaml file from /var/lib/jenkins/app-deployment/deployment.yaml to Jenkins workspace.
---
## Jenkins Pipeline Configuration
### Environment Variables
```
DOCKER_CREDENTIALS_ID = 'docker-hub'  // Docker Hub credentials ID
IMAGE_NAME = 'ranasalem2412/rana_image' // Docker image name on Docker Hub
DEPLOYMENT_FILE = 'deployment.yaml'   // Kubernetes deployment file
KUBECONFIG_PATH = '/home/ec2-user/kubeconfig.yaml' // Path to kubeconfig
```
### Pipeline Stages
#### Clone Repository
##### Clone the Dockerfile repository from GitHub:
```
git branch: 'main', url: 'https://github.com/IbrahimAdell/App1.git'
```
### Build Docker Image
#### Build the Docker image from the Dockerfile:
```
script {
    def IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    sh "docker build -t ${IMAGE_TAG} ."
}
```
### Login to Docker Hub
#### Use credentials to log in to Docker Hub:
```
withCredentials([usernamePassword(credentialsId: DOCKER_CREDENTIALS_ID, usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
    sh """
        echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin
    """
}
```
### Push Docker Image
#### Push the Docker image to Docker Hub:
```
script {
    def IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    sh "docker push ${IMAGE_TAG}"
}
```
### Clean Up Local Images
#### Remove the locally built Docker image:
```
script {
    def IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    sh "docker rmi ${IMAGE_TAG}"
}
```
### Copy Deployment File to Workspace
#### Copy the deployment.yaml file into the Jenkins workspace:
```
sh """
    cp /var/lib/jenkins/app-deployment/deployment.yaml .
    ls -la  # Confirm the file was copied
"""
```
### Update Deployment File
#### Update the deployment.yaml file to use the new image:
```
 script {
    def IMAGE_TAG = "${IMAGE_NAME}:${BUILD_NUMBER}"
    sh """
        sed -i 's|image:.*|image: ${IMAGE_TAG}|' ${DEPLOYMENT_FILE}
        cat ${DEPLOYMENT_FILE}  # Confirm the change
    """
}
```
### Deploy to Kubernetes
#### Deploy the updated application to Kubernetes using kubectl:
```
withCredentials([file(credentialsId: 'kubeconfigg', variable: 'KUBECONFIG')]) {
    script {
        def exitCode = sh(
            script: '''
                kubectl --kubeconfig=$KUBECONFIG apply -f ${DEPLOYMENT_FILE}
            ''',
            returnStatus: true
        )
        if (exitCode != 0) {
            error "Kubernetes Deployment Failed!"
        }
    }
}
```
### Post Actions
#### Always Executed: Print a message when the pipeline finishes.
#### Success: Print a success message if the deployment is successful.
#### Failure: Print a failure message if the deployment fails.
```
post {
    always {
        echo "Pipeline Finished - Always Executed"
    }
    success {
        echo "Deployment Successful!"
    }
    failure {
        echo "Deployment Failed!"
    }
}
```
## Verification Steps
### Check Pods
#### To check the status of the Pods, run:
```
kubectl get pods
```
### Check Services
#### To check the Kubernetes services, run:
```
kubectl get services
```
### Check Deployments
#### To check the Kubernetes deployments, run:
```
kubectl get deployments
```
### Check Nodes
#### To check the status of the Kubernetes nodes, run:
```
kubectl get nodes -o wide
```
### Access the Application
#### To confirm that the application was deployed successfully, you can access it via the Public IP of the EC2 instance on port 30001:
```
http://http://EC2-IP>/:30001
```
##### Where <EC2-IP>=3.92.237.200 is the public IP of your EC2 instance
---
## Conclusion
### This pipeline automates the entire process of building a Docker image, pushing it to Docker Hub, updating the Kubernetes deployment file, and deploying it to Kubernetes. The Jenkins pipeline is fully automated and ensures that every deployment is consistent and repeatable.


































