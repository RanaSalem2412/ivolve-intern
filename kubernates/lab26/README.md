# Lab 26: Updating Applications and Rolling Back Changes
### • Deploy NGINX with 3 replicas.
### • Create a service to expose NGINX deployment.
### • Use port forwarding to access NGINX service locally.
### • Update NGINX image to Apache.
### • View deployment's rollout history.
### • Roll back NGINX deployment to the previous image version and Monitor pod status
## 1-Setup the Environment
### iam working on:
#### Minikube running on an EC2 instance for Kubernetes.
#### Using kubectl to execute commands.
### Verify Kubernetes Cluster
```
kubectl cluster-info
kubectl get nodes
```
## 2-Deploy NGINX with 3 Replicas
### Create Deployment YAML File
#### Create a file named nginx-deployment.yaml with the following content:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:latest
        ports:
        - containerPort: 80
```
## Apply the Deployment
### Run the following command to deploy NGINX:
```
kubectl apply -f nginx-deployment.yaml
```
## Verify Deployment
### Check the status of the deployment:
```
kubectl get deployments
kubectl get pods
```
##### see 3 running Pods using the NGINX image.
## 3-Create a Service to Expose NGINX
### Create Service YAML File
#### Create a file named nginx-service.yaml with the following content:
```
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
  type: ClusterIP
```
###  Apply the Service
#### Run the following command:
```
kubectl apply -f nginx-service.yaml
```
### Verify the Service
```
kubectl get svc
```
## 4-Use Port Forwarding to Access NGINX Locally
### Run the following command in new terminal:
```
kubectl port-forward svc/nginx-service 8080:80
```
### Then write this:
```
curl http://localhost:8080
```
## 5-Update NGINX to Apache
### To update the NGINX image to Apache, run:
```
kubectl set image deployment/nginx-deployment nginx=httpd:latest
```
### Verify the Update
```
kubectl rollout status deployment/nginx-deployment
kubectl get pods
```
## 6. View Rollout History
### To check the deployment rollout history, run:
```
kubectl rollout history deployment/nginx-deployment
```
#### You should see two revisions:
##### Revision 1: Running nginx:latest.
##### Revision 2: Updated to httpd:latest (Apache).
## 7-Roll Back to NGINX
```
 kubectl rollout undo deployment/nginx-deployment
```
### Verify After Rollback
```
kubectl rollout history deployment/nginx-deployment
kubectl get pods
```





















