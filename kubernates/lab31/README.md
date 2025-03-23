# Lab 31: Storing Data & set resources limits
### * Create a namespace called iVolve and apply resource quota to limit pods number within the namespace.
### * Create a Deployment in iVolve namespace for MySQL with resources requests: CPU: 0.5 CPU, Mem: 1G, and resources limits: CPU: 1 vCPU, Mem: 2G.
### * Define MySQL database name and user in a ConfigMap.
### * Store the MySQL root password and user password in a Secret.
### * Exec into the MySQL pod and verify the Database configurations.
---
## 1. Create Namespace
#### Command:
```
kubectl create namespace ivolve
```
## 2. Create ResourceQuota
#### resource-quota.yaml Content:
```
apiVersion: v1
kind: Namespace
metadata:
  name: ivolve
---
apiVersion: v1
kind: ResourceQuota
metadata:
  name: pod-limit
  namespace: ivolve
spec:
  hard:
    pods: "5"  # Limit to 5 Pods in this Namespace
```
#### Apply ResourceQuota:
```
kubectl apply -f resource-quota.yaml
```
## 3. Create MySQL Deployment
#### mysql-deployment.yaml Content:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mysql-deployment
  namespace: ivolve
spec:
  replicas: 1
  selector:
    matchLabels:
      app: mysql
  template:
    metadata:
      labels:
        app: mysql
    spec:
      containers:
        - name: mysql
          image: mysql:5.7
          resources:
            requests:
              cpu: "500m"
              memory: "1Gi"
            limits:
              cpu: "1"
              memory: "2Gi"
          env:
            - name: MYSQL_ROOT_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: mysql-root-password
            - name: MYSQL_DATABASE
              valueFrom:
                configMapKeyRef:
                  name: mysql-config
                  key: database
            - name: MYSQL_USER
              valueFrom:
                configMapKeyRef:
                  name: mysql-config
                  key: user
```
#### Apply MySQL Deployment:
```
kubectl apply -f mysql-deployment.yaml
```
## 4. Create ConfigMap for MySQL
#### mysql-configmap.yaml Content:
```
apiVersion: v1
kind: ConfigMap
metadata:
  name: mysql-config
  namespace: ivolve
data:
  database: ivolve_db
  user: ivolve_user
```
#### Apply ConfigMap:
```
kubectl apply -f mysql-configmap.yaml
```
## 5. Create Secret for MySQL Passwords
#### mysql-secret.yaml Content:
```
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
  namespace: ivolve
type: Opaque
data:
  mysql-root-password: <base64-encoded-root-password>
  mysql-user-password: <base64-encoded-user-password>
```
#### Note: Encode your passwords in base64 using the following command:
```
echo -n "your-password" | base64
```
#### Apply Secret:
```
kubectl apply -f mysql-secret.yaml
```
## 6. Verify MySQL Setup
#### Command to access MySQL Pod:
```
kubectl exec -it <mysql-pod-name> -n ivolve -- bash
```
#### Once inside the pod, you can use the following commands to verify MySQL:
```
mysql -u root -p 
SHOW DATABASES;  
```






