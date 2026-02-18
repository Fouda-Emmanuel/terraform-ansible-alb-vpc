# Terraform & Ansible ALB VPC Architecture

## Project Overview
This project builds a production-style, highly available web architecture in AWS using Terraform and Ansible.

It provisions a custom VPC, multi-AZ infrastructure, and an Application Load Balancer (ALB).  
EC2 instances are configured using an Ansible Nginx role.  
Terraform state is stored remotely in an S3 backend.

## Architecture

- Custom VPC
- 2 Public Subnets (different Availability Zones)
- Internet Gateway
- Route Table (0.0.0.0/0 → IGW)
- 2 EC2 instances (web01, web02)
- Application Load Balancer (ALB) NOTE we used classic Load Balancer instead
- Target Group
- S3 Remote Backend for Terraform state

```

VPC
├── Public Subnet AZ-a → web01
├── Public Subnet AZ-b → web02
├── Internet Gateway
└── Application Load Balancer
└── Target Group
├── web01
└── web02

````

Traffic Flow:
Browser → ALB → Target Group → EC2 Instances

## Security Design

- ALB Security Group:
  - Allow HTTP (80) from 0.0.0.0/0
- EC2 Security Group:
  - Allow HTTP (80) from ALB Security Group only
  - Allow SSH (22) from my IP only

EC2 instances are **not publicly exposed directly**.

## Remote State Configuration

Terraform backend configured with S3:

- S3 bucket created manually
- Versioning enabled
- Encryption enabled
- State stored at: `project3/terraform.tfstate`

After backend configuration:

```bash
terraform init
````

State is migrated to S3.

## How to Deploy

### 1. Provision Infrastructure

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### 2. Configure Servers

```bash
cd ansible
ansible-playbook -i inventory/hosts.yml playbooks/site.yml
```

## How to Test

Access the application using the ALB DNS name:

```
http://<ALB-DNS>
```

Traffic is distributed between:

* web01
* web02

Each instance serves a custom Nginx page.

## Cleanup

```bash
cd terraform
terraform destroy
```

## Key Concepts Demonstrated

* Custom VPC design
* Multi-AZ high availability
* Classic Load Balancer configuration
* Target Group attachment
* Security group chaining
* Terraform remote backend (S3)
* Infrastructure isolation
* Proper tagging strategy
* Production-style architecture

