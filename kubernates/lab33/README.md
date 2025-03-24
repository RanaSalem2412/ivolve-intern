# Lab 33: Multi-container Applications
### •Create a deployment for Jenkins with an init container that sleeps for 30 seconds.
### •Use readiness and liveness probes.
### •Create a NodePort service to expose Jenkins.
### •Verify that the init container runs successfully and Jenkins is properly initialized.
### •Make comparison between Readiness / Liveness probes & Init / Sidecar containers
---
## 1. Create the YAML file for the Deployment
#### Create a file named jenkins-deployment.yaml with the following content:
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: jenkins-deployment
spec:
  replicas: 1
  selector:
    matchLabels:
      app: jenkins
  template:
    metadata:
      labels:
        app: jenkins
    spec:
      initContainers:
      - name: init-sleep
        image: busybox
        command: ['sleep', '30']
        imagePullPolicy: Always
      containers:
      - name: jenkins
        image: jenkins/jenkins:lts
        ports:
        - containerPort: 8080
        readinessProbe:
          httpGet:
            path: /login
            port: 8080
        livenessProbe:
          httpGet:
            path: /login
            port: 8080
        env:
        - name: JAVA_OPTS
          value: "-Djenkins.install.runSetupWizard=false"
---
apiVersion: v1
kind: Service
metadata:
  name: jenkins-service
spec:
  type: NodePort
  selector:
    app: jenkins
  ports:
    - port: 8080
      targetPort: 8080
      nodePort: 30080
```
## 2. Apply the Deployment and Service
#### To apply the YAML file, run the following command:
```
kubectl apply -f jenkins-deployment.yaml
```
## 3. Verify that the Init Container is running correctly
#### To verify that the init container ran successfully, use the following commands:
```
kubectl get pods
```
#### Find the pod for Jenkins, then run the following command to get detailed information:
```
kubectl describe pod <jenkins-pod-name>
```
##### Ensure that the init container completed the sleep 30 process before the Jenkins container started.
## 4. Verify the Readiness and Liveness Probes
#### To check that the Readiness and Liveness probes are working correctly, view the pod logs with the command:
```
kubectl logs <jenkins-pod-name>
```
##### Look for any messages related to the readiness or liveness probes.
## 5. Access Jenkins via NodePort
#### Since the service is of type NodePort, you can access Jenkins using the EC2 instance's IP address running Minikube and port 30080.
#### For example, if your EC2 instance has the IP x.x.x.x, you can access Jenkins via:
```
http://x.x.x.x:30080
```
