# Day 62 – Terraform Providers, Resources & Dependencies

## 📌 Overview

Today I learned how Terraform manages AWS infrastructure using **providers, resources, dependencies, lifecycle rules, and dependency graphs**.

I built a complete AWS networking stack using Terraform and understood how Terraform determines the order in which resources should be created and destroyed.

---

## 🎯 Objectives

* Configure the AWS Terraform Provider
* Understand provider version constraints
* Create a VPC and public subnet
* Configure Internet Gateway and Route Table
* Create a Security Group
* Launch an EC2 instance
* Understand implicit and explicit dependencies
* Use `depends_on`
* Visualize dependencies using `terraform graph`
* Understand Terraform lifecycle rules
* Destroy infrastructure using Terraform

---

## 📁 Project Structure

```text
day-62/
├── terraform-aws-infra/
│   ├── providers.tf
│   ├── main.tf
│   ├── graph.png
│   └── .terraform.lock.hcl
│
└── day-62-providers-resources.md
```

---

# 1️⃣ AWS Provider

Created `providers.tf`:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}
```

Initialized Terraform:

```bash
terraform init
```

### Version Constraint

| Constraint | Meaning                      |
| ---------- | ---------------------------- |
| `~> 5.0`   | Allows 5.x versions, not 6.x |
| `>= 5.0`   | Allows 5.0 and newer         |
| `= 5.0.0`  | Allows only 5.0.0            |

The `.terraform.lock.hcl` file locks the selected provider version and checksums to make installations reproducible.

---

# 2️⃣ AWS Infrastructure

Created the following resources:

```text
VPC
 ├── Public Subnet
 ├── Internet Gateway
 ├── Route Table
 │     └── Route Table Association
 ├── Security Group
 │     └── EC2 Instance
 │
 └── S3 Bucket
```

### VPC

```text
CIDR: 10.0.0.0/16
Name: TerraWeek-VPC
```

### Subnet

```text
CIDR: 10.0.1.0/24
Name: TerraWeek-Public-Subnet
```

The subnet references:

```hcl
vpc_id = aws_vpc.main.id
```

which creates an **implicit dependency**.

---

# 3️⃣ Security Group & EC2

Created a Security Group allowing:

```text
SSH  → Port 22
HTTP → Port 80
```

Created an EC2 instance with:

```text
AMI           → Amazon Linux 2
Instance Type → t2.micro
Public IP     → Enabled
```

The EC2 instance depends on the subnet and security group.

---

# 4️⃣ Terraform Dependencies

### Implicit Dependency

Terraform automatically detects dependencies through resource references.

Example:

```hcl
subnet_id = aws_subnet.public.id
```

Terraform understands:

```text
Subnet → depends on → VPC
```

### Explicit Dependency

Used `depends_on` when the dependency is logical but not directly referenced:

```hcl
depends_on = [
  aws_instance.main
]
```

This makes Terraform create the S3 bucket after the EC2 instance.

---

# 5️⃣ Dependency Graph

Generated the Terraform dependency graph using:

```bash
terraform graph
```

Saved the graph:

```bash
terraform graph > graph.dot
```

With Graphviz:

```bash
terraform graph | dot -Tpng > graph.png
```

The graph shows how Terraform determines the order of resource creation and destruction.

---

# 6️⃣ Lifecycle Rules

Used:

```hcl
lifecycle {
  create_before_destroy = true
}
```

This tells Terraform to create a replacement resource before destroying the existing one.

### Important lifecycle arguments

| Argument                | Purpose                                           |
| ----------------------- | ------------------------------------------------- |
| `create_before_destroy` | Create replacement before destroying old resource |
| `prevent_destroy`       | Prevent accidental deletion                       |
| `ignore_changes`        | Ignore changes to selected attributes             |

---

# 7️⃣ Terraform Commands

```bash
terraform init
terraform fmt
terraform validate
terraform plan
terraform apply
terraform graph
terraform state list
terraform destroy
```

---

# 📸 Evidence

Screenshots included for:

* `terraform init`
* `terraform plan`
* `terraform apply`
* AWS VPC resources
* EC2 instance
* Terraform dependency graph
* Resource destruction

---

# 🧠 Key Learning

The main takeaway from Day 62 was understanding that **Terraform doesn't simply execute resources from top to bottom**.

It builds a **dependency graph** from the relationships between resources and uses that graph to determine the correct creation, update, and destruction order.

> **You define the desired infrastructure — Terraform determines how to build it.**

---

## ✅ Day 62 Completed

**90 Days of DevOps | TerraWeek**

Learned AWS Infrastructure as Code with Terraform and built a complete networking stack from scratch.

#90DaysOfDevOps #TerraWeek #Terraform #AWS #DevOps #InfrastructureAsCode
