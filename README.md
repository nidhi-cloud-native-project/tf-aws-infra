# Assignment-03  

# **Terraform AWS Infrastructure Setup**

This repository contains Terraform configuration files to provision AWS networking resources such as **Virtual Private Cloud (VPC)**, **Subnets**, **Internet Gateway**, and **Route Tables**.

## **Prerequisites**
Before running Terraform, ensure you have the following installed and configured:

1. **Terraform** (v1.4.6 or later) → [Download Terraform](https://developer.hashicorp.com/terraform/downloads)
2. **AWS CLI** (latest version) → [Install AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html)
3. **Git** (latest version) → [Install Git](https://git-scm.com/)
4. **IAM User** with permissions to create networking resources in AWS
5. **GitHub Account** with access to this repository

## **Download the Terraform Code from GitHub**
1. **Clone the Repository** : Use git command to clone the repository to your local machine
2. **Navigate into the cloned repository**

# Setting Up Terraform

**1. Configure AWS CLI:**   
Ensure you have the AWS CLI configured with the correct profiles:

```bash
aws configure --profile dev
aws configure --profile demo
```

For each profile, enter:   
AWS Access Key ID   
AWS Secret Access Key   
Default AWS Region (us-east-1)   
Output Format: json   

To verify the profiles:

```bash
aws sts get-caller-identity --profile dev
aws sts get-caller-identity --profile demo
```

**2. Navigate to the Terraform Directory:**   
Go to the VPC directory and Initialize Terraform:

```bash
terraform init
```

**3. Format and Validate Terraform Code:**   
Run formatting and validation checks before applying:

```bash
terraform fmt             # Ensures code consistency
terraform validate        # Validates Terraform configuration
```

**4. Apply Terraform Configuration:**   
To create the AWS infrastructure, run:

```bash
terraform apply -var-file=dev.tfvars
```

**5. Verify AWS Resources:**   
To check created VPCs and Subnets:

```bash
aws ec2 describe-vpcs --profile dev
aws ec2 describe-subnets --profile dev
```

To view resources in AWS Console:   
Log in to AWS Console.   
Navigate to VPC Dashboard.   
Ensure you have selected the correct AWS Region.   

**6. Destroy Terraform Infrastructure:**   
To remove all resources:

```bash
terraform destroy -var-file=dev.tfvars -auto-approve
```