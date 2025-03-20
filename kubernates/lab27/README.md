# Lab 27: Deployment vs. StatefulSet
### * Make a Comparison between Deployment and Statefulset.
### * Create a YAML file for a MySQL Statefulset configuration with 3 replicas.
### * Write a YAML file to define a service for the MySQL Statefulset.
## Create a MySQL StatefulSet
### Step 1: Create the file
```
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: "mysql"
  replicas: 3
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
          env:
            - name: MYSQL_ROOT_PASSWORD
              value: "rootpassword"
            - name: MYSQL_DATABASE
              value: "mydatabase"
          ports:
            - containerPort: 3306
              name: mysql
          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql
  volumeClaimTemplates:
    - metadata:
        name: mysql-storage
      spec:
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 1Gi

```
### Step 2: Apply the StatefulSet
```
kubectl apply -f mysql-statefulset.yaml
```
### Step 3: Verify the Pods
```
kubectl get pods -o wide
```
## Create a Service for MySQL StatefulSet
### Step 1: Create the file
```
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
    - name: mysql
      port: 3306
      targetPort: 3306
```
### Step 2: Apply the Service
```
kubectl apply -f mysql-service.yaml
```
### Step 3: Verify the Service
```
kubectl get svc mysql
```
##  Connect to MySQL Database
### Step 1: Access the MySQL Pod
```
kubectl exec -it mysql-0 -- mysql -u root -p
```
### Then enter the password:
```
rootpassword
```
### Step 2: Show Databases
```
SHOW DATABASES;
```














