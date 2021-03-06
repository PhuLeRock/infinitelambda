
## InfiniteLambda assignment 
### Prerequisite: 
awscli is already installed, and please add your access key ad access key id. I configured my default region in 'ap-southeast-1' (hardcode)
pythonapp/docker-compose.yaml file can run only in the ec2 machine which is the same AWS VPC with RDS postgres.
### 1. Create infrastructure with Terraform (infrastructure/)
Edit file infrastructure/terraform.tfvars to add your both ssh public and private key.
Run command:
```
terraform apply -auto-approve
```
You will receive the temporary password of Jenkins in the profress like this:
```
aws_instance.dev (local-exec):     "result.stdout": "205a80e2453f44d091ee27a87a9f74ff"
```
and all the output like this:
```
Outputs:

Database_Name = "rds-identifier.cypb6g6h5ipw.ap-southeast-1.rds.amazonaws.com:5432"
ECR_url = "667656621301.dkr.ecr.ap-southeast-1.amazonaws.com/pyapp"
Jenkins = "http://13.250.47.80:3389"
website_URL = "http://infinitedevopstest.s3-website-ap-southeast-1.amazonaws.com"
```
### 2. Configure your brand new Jenkins 
open the Jenkins URL you received in the output of Terraform, login with the temporary password.
 - Install all suggested plugin.
 - change pass jenkins -> Login jenkins
 - Go to Manager plugin suggest plugins and docker-common, docker pipeline, amazon-ecr
 - Go to manage credential -> add credential aws and github (username and password for https method)

### 3. Create pipeline job "s3static" 
Gitt URL: `https://github.com/PhuLeRock/infinitelambda.git`

Jenkinsfile location: `s3static/Jenkinsfile`

Click run and check the output with the `website_URL` in Terraform's output.

### 4. Create pipeline job "pyapp"
Visit the file pythonapp/Jenkinsfile, entry all variables in `environment {..}`
Now you can crate pipeline job with these infoation:
Gitt URL: `https://github.com/PhuLeRock/infinitelambda.git`

Jenkinsfile location: `s3static/Jenkinsfile`

### NOTE:
In case you don't want to build and run pyapp with Jenkins, you can run pythonapp/docker-compose.yaml in ec2 machine (read Prerequisite).


