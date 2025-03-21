# Lab 14: SDK and CLI Interactions
## Objective
### This lab focuses on using AWS CLI to interact with Amazon S3. The key objectives are:
#### Creating an S3 bucket.
#### Configuring permissions.
#### Uploading and downloading files.
#### Enabling versioning.
#### Setting up logging.
## Prerequisites
#### You are working on AWS Learner Lab with Cloud9 as your environment.
#### AWS CLI is pre-installed.
---
### Step 1: Create an S3 Bucket
##### Run the following command to create a new S3 bucket:
```
aws s3 mb s3://my-learner-bucket-12345
```
##### Verify bucket creation:
```
aws s3 ls
```
---
### Step 2: Upload and Download Files
##### Upload a file to the bucket:
```
echo "Hello, AWS!" > test.txt
aws s3 cp test.txt s3://my-learner-bucket-12345/
```
##### List files in the bucket:
```
aws s3 ls s3://my-learner-bucket-12345/
```
##### Download the file:
```
aws s3 cp s3://my-learner-bucket-12345/test.txt downloaded-test.txt
```
---
### Step 3: Enable Versioning
##### Enable versioning on the bucket:
```
aws s3api put-bucket-versioning --bucket my-learner-bucket-12345 --versioning-configuration Status=Enabled
```
##### Verify versioning:
```
aws s3api get-bucket-versioning --bucket my-learner-bucket-12345
```
##### Upload a modified version of the file:
```
echo "Updated content" > test.txt
aws s3 cp test.txt s3://my-learner-bucket-12345/
```
##### List object versions:
```
aws s3api list-object-versions --bucket my-learner-bucket-12345
```
---
### Step 4: Enable Logging
##### Create a new bucket for logs:
```
aws s3 mb s3://my-learner-bucket-logs-12345
```
##### Enable logging:
```
aws s3api put-bucket-logging --bucket my-learner-bucket-12345 --bucket-logging-status '{
  "LoggingEnabled": {
    "TargetBucket": "my-learner-bucket-logs-12345",
    "TargetPrefix": "logs/"
  }
}'
```
#####
Verify logging:
```
aws s3api get-bucket-logging --bucket my-learner-bucket-12345
```
---
### Step 5: Check Public Access Configuration
##### Check if public access block is configured:
```
aws s3control get-public-access-block --account-id $(aws sts get-caller-identity --query "Account" --output text)
```
###### if no configuration is found, you may see an error message, which means no public access restrictions exist.



