# Terraform

Download [terraform](https://www.terraform.io/downloads.html)

```bash
unzip terraform.zip
cp terraform /usr/local/bin/terraform
chmod u+x /usr/local/bin/terraform
terraform version
```

## AWS authentication

Please use your crenetials.csv file that you download when create IAM user or generate
new one.
Create file `~/aws_creds.txt` with such content:

```bash
export AWS_ACCESS_KEY_ID=""
export AWS_SECRET_ACCESS_KEY=""
```

Before start terraform commands please do:

```bash
source ~/aws_creds.txt
```

More info how to authenticate in AWS you can find [here](https://www.terraform.io/docs/providers/aws/index.html#authentication)

## Install awscli

```bash
easy_install pip
pip install awscli
aws configure
```

## Configure and run first project

Before start we need to set ENV variables
```bash
cd simple-ec2-creation
export TF_VAR_vpc_id=$(aws ec2 describe-vpcs --filters "Name=isDefault, Values=true" --query 'Vpcs[*].{id:VpcId}' --output text --region eu-west-1)
export TF_VAR_subnet_id=$(aws ec2 describe-subnets --query 'Subnets[0].{id:SubnetId}' --output text --region eu-west-1)
export TF_VAR_env=dev
```

```bash
terraform init
terraform plan
terraform apply
```

### Create S3 bucket for storing states

```bash
aws s3api create-bucket --bucket itea-tf-<YOUR_NAME> --region eu-west-1
```

### Config remote state
Please open text editor and in config directory rename all `@@bucket@@` placeholders with name of your bucket for states

### Init terraform with remote state

```bash
terraform init -backend-config=config/${TF_VAR_env}-state.conf
terraform plan
terraform apply
```

### Use tfvars to deploy different environment

```bash
terraform plan -var-file=environment/${TF_VAR_env}.tfvars
terraform apply -var-file=environment/${TF_VAR_env}.tfvars
terraform destroy -var-file=environment/${TF_VAR_env}.tfvars
```

# Terraform modules

## Simple ec2 creation with module from terraform registry

```bash
cd ec2_with_module
terraform plan
terraform apply
```

## Create base AWS setup with VPC with custom module

```bash
cd base_aws_setup
export TF_VAR_env=prod
terraform init -backend-config=config/${TF_VAR_env}-state.conf
terraform apply -var-file=environment/${TF_VAR_env}.tfvars
terraform destroy -var-file=environment/${TF_VAR_env}.tfvars
```
