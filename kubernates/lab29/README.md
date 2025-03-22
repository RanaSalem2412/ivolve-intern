# Lab 29: Security and RBAC
### * Create a Service Account with token.
### *Define a Role named pod-reader allowing read-only access to pods in the names pace.
### *Bind the pod-reader Role to the Service Account.
### *Make a Comparison between service account - role & role binding - and cluster role & cluster role binding.
## 1. Create a Service Account
#### Create a YAML file named service-account.yaml and add the following content:
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: my-service-account  
  namespace: default
```
#### Apply the Service Account:
```
kubectl apply -f service-account.yaml
```
### Generate a Token for the Service Account
#### To generate a token for this Service Account, run:
```
kubectl create token my-service-account --namespace=default
```
## 2. Create a Role with Read-Only Access to Pods
#### Create a YAML file named role.yaml and add the following content:
```
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: pod-reader
  namespace: default
rules:
- apiGroups: [""]
  resources: ["pods"]
  verbs: ["get", "list", "watch"]
```
#### Apply the Role:
```
kubectl apply -f role.yaml
```
## 3. Bind the Role to the Service Account
#### Create a YAML file named role-binding.yaml and add the following content:
```
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: pod-reader-binding
  namespace: default
subjects:
- kind: ServiceAccount
  name: my-service-account
  namespace: default
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```
#### Apply the RoleBinding:
```
kubectl apply -f role-binding.yaml
```
## 5. Verification Commands
#### List all Service Accounts in the default namespace
```
kubectl get serviceaccounts -n default
```
#### List all Roles in the default namespace
```
kubectl get roles -n default
```
#### List all RoleBindings in the default namespace
```
kubectl get rolebindings -n default
```
