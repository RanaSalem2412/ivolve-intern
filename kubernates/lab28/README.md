# Lab 28: Storage Configuration
### * Create Ngin deployment with 1 replica.
### * Exec into the pod and create a file at /us/share/nginx/html/hello.txt with the content "hello iVolve"
### * verify the file is served by using curl localhost/hello.txt.
### * Delete the NGINX pod and wait for the deployment to create a new pod
### * exec into the new pod and verify the file at /us/share/nginx/html/hello.txt is no longer present.
### * Create a Persistent Volume Claim (PVC).
### * Modify the deployment to attach the PVC to the pod at /ust/share/nginx/html.
### * Repeat the previous steps and Verify the file persists across pod deletions
## Problem Statement
### When deploying an Nginx pod in Kubernetes, files created inside /usr/share/nginx/html/ are lost when the pod is deleted and recreated. This happens because the container filesystem is ephemeral.
## Solution
### To ensure that files persist across pod deletions, we need to attach a Persistent Volume Claim (PVC) to our Nginx deployment.
## Steps to Implement Persistent Storage for Nginx
### 1. Create an Nginx Deployment
##### First, deploy an Nginx pod with a standard deployment.
#### nginx-deployment.yaml:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
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
#### Apply the deployment:
```
kubectl apply -f nginx-deployment.yaml
```
#### Verify that the pod is running:
```
kubectl get pods
```
### 2. Create a Test File in the Pod
#### Exec into the running pod and create a test file:
```
kubectl exec -it <nginx-pod-name> -- /bin/bash
```
#### Inside the pod, create the file:
```
echo "hello iVolve" > /usr/share/nginx/html/hello.txt
exit
```
#### Verify the file is served:
```
kubectl exec -it <nginx-pod-name> -- curl localhost/hello.txt
```
### 3. Delete the Pod and Check if the File Persists
#### Delete the running pod:
```
kubectl delete pod <nginx-pod-name>
```
#### Wait for Kubernetes to recreate a new pod and check for the file:
```
kubectl exec -it <new-nginx-pod-name> -- ls /usr/share/nginx/html/
```
###### If hello.txt is missing, we need to attach persistent storage.
### 4. Create a Persistent Volume Claim (PVC)
#### Create a PVC to request persistent storage:
##### nginx-pvc.yaml:
```
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: nginx-pvc
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
#### Apply the PVC:
```
kubectl apply -f nginx-pvc.yaml
```
#### Verify that the PVC is created:
```
kubectl get pvc
```
### 5. Modify the Deployment to Use the PVC
#### Update nginx-deployment.yaml to use the PVC:
##### Updated nginx-deployment.yaml:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 1
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
        volumeMounts:
        - mountPath: "/usr/share/nginx/html"
          name: nginx-storage
      volumes:
      - name: nginx-storage
        persistentVolumeClaim:
          claimName: nginx-pvc
```
#### Apply the updated deployment:
```
kubectl apply -f nginx-deployment.yaml
```
### 6. Verify Persistent Storage is Working
#### 1-Create the file again in the new pod:
```
kubectl exec -it <nginx-pod-name> -- /bin/bash
echo "hello iVolve" > /usr/share/nginx/html/hello.txt
exit
```
#### 2-Delete the pod:
```
kubectl delete pod <nginx-pod-name>
```
#### 3-Check if the file still exists in the new pod:
```
kubectl exec -it <new-nginx-pod-name> -- cat /usr/share/nginx/html/hello.txt
```













