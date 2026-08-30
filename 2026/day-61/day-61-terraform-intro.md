# Day 61 – Introduction to Terraform and My First AWS Infrastructure

## 🚀 90 Days of DevOps – Day 61

Today I started my **Infrastructure as Code (IaC)** journey with **Terraform**.

After working with Docker, CI/CD, and Kubernetes, today's focus was understanding how the infrastructure underneath these technologies can also be created and managed using code.

Instead of manually creating resources through the AWS Console, I used Terraform to provision an **S3 bucket and an EC2 instance**, inspect Terraform state, modify infrastructure, and finally destroy the resources.

---

## 🏗️ What is Infrastructure as Code?

Infrastructure as Code means managing infrastructure using configuration files instead of manually creating everything through a cloud provider's graphical interface.

With IaC, infrastructure becomes repeatable, version-controlled, reviewable, and easier to automate.

For example, instead of manually creating an EC2 instance from the AWS Console, I can describe the desired infrastructure in a `.tf` file and let Terraform create it.

This makes infrastructure management much more suitable for DevOps and CI/CD workflows.

---

## 🤔 What Problems Does IaC Solve?

Manual infrastructure management can lead to:

* Configuration mistakes
* Inconsistent environments
* Difficult-to-repeat deployments
* Lack of infrastructure history
* Manual and time-consuming changes
* Problems when multiple people manage the same infrastructure

IaC helps solve these problems by treating infrastructure like application code.

I can:

* Store infrastructure configuration in Git
* Review infrastructure changes
* Recreate environments consistently
* Automate deployments
* Track infrastructure changes
* Destroy resources when they are no longer needed

---

## ⚔️ Terraform vs Other IaC Tools

| Tool                   | Main Idea                                                               |
| ---------------------- | ----------------------------------------------------------------------- |
| **Terraform**          | Declarative infrastructure provisioning across multiple cloud providers |
| **AWS CloudFormation** | AWS-native infrastructure management                                    |
| **Ansible**            | Mainly configuration management and automation                          |
| **Pulumi**             | Infrastructure as Code using general-purpose programming languages      |

Terraform stood out to me because it provides a declarative configuration language and supports many infrastructure providers.

---

## 📌 Declarative and Cloud-Agnostic

### Declarative

Terraform configuration describes **what the infrastructure should look like**, rather than giving Terraform a step-by-step list of commands.

For example:

```hcl
resource "aws_instance" "web" {
  ami           = "ami-example"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}
```

I describe the desired EC2 instance, and Terraform determines the actions required to reach that desired state.

### Cloud-Agnostic

Terraform is not limited to AWS.

The same Terraform workflow can be used with providers for platforms such as:

* AWS
* Azure
* Google Cloud
* Kubernetes
* GitHub
* Cloudflare

This allows Terraform to manage infrastructure across different platforms using a consistent workflow.

---

# 🛠️ Terraform Installation

First, I installed Terraform and verified the installation.

```bash
terraform -version
```

Example:

```text
Terraform v1.x.x
```

I also configured the AWS CLI:

```bash
aws configure
```

Then verified my AWS credentials:

```bash
aws sts get-caller-identity
```

This confirmed that the AWS CLI could successfully communicate with my AWS account.

---

# 🪣 Creating My First S3 Bucket

I created a Terraform project:

```bash
mkdir terraform-basics
cd terraform-basics
```

My `main.tf` contained:

```hcl
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "terraform_bucket" {
  bucket = "terraweek-aishwary-2026"
}
```

> Make sure the bucket name is globally unique before applying.

---

## 🔄 Terraform Lifecycle

### 1. Initialize

```bash
terraform init
```

Terraform downloaded the required AWS provider and prepared the working directory.

### What did `terraform init` download?

It downloaded the Terraform provider plugin required to communicate with AWS.

The provider acts as the bridge between Terraform and the AWS APIs.

The `.terraform/` directory contains Terraform's local working data, including downloaded provider plugins and related dependency information.

---

### 2. Format

```bash
terraform fmt
```

Automatically formats Terraform configuration files into the standard Terraform style.

---

### 3. Validate

```bash
terraform validate
```

Checks whether the Terraform configuration is syntactically valid and internally consistent.

---

### 4. Plan

```bash
terraform plan
```

Shows what Terraform intends to change without actually making those changes.

---

### 5. Apply

```bash
terraform apply
```

Creates or modifies the infrastructure described in the configuration.

After reviewing the plan, I confirmed the operation.

---

## 📸 Terraform Apply

*Add screenshot here showing the S3 bucket being created.*

```text
Screenshot:
terraform apply → S3 bucket creation
```

---

# 🖥️ Adding an EC2 Instance

Next, I added an EC2 instance to the same Terraform configuration.

```hcl
resource "aws_instance" "web" {
  ami           = "YOUR_REGION_AMI_ID"
  instance_type = "t2.micro"

  tags = {
    Name = "TerraWeek-Day1"
  }
}
```

The AMI ID must match the AWS region being used.

For my configuration, the region was:

```text
ap-south-1
```

I then ran:

```bash
terraform plan
```

Terraform identified that the S3 bucket was already being managed and that the EC2 instance needed to be created.

Then:

```bash
terraform apply
```

---

## 📸 AWS Console

*Add screenshot showing the S3 bucket in the AWS Console.*

*Add screenshot showing the EC2 instance with the **`TerraWeek-Day1`** tag.*

---

# 🧠 How Does Terraform Know the S3 Bucket Already Exists?

Terraform uses its **state file** to keep track of infrastructure it manages.

The local state file is:

```text
terraform.tfstate
```

After creating the S3 bucket, Terraform recorded information about that resource in the state.

When I added the EC2 resource and ran:

```bash
terraform plan
```

Terraform compared:

```text
Terraform configuration
        ↓
Terraform state
        ↓
Real infrastructure
```

Because the S3 bucket was already tracked in the state, Terraform did not need to create another bucket.

It only planned the EC2 resource that was missing from the desired configuration/state.

---

# 📦 Understanding Terraform State

Terraform stores information about managed infrastructure in:

```text
terraform.tfstate
```

I inspected it with:

```bash
terraform show
```

This provides a human-readable representation of the current state.

---

## List Resources

```bash
terraform state list
```

Example:

```text
aws_s3_bucket.terraform_bucket
aws_instance.web
```

This shows the resources currently managed by Terraform.

---

## Inspect S3 Resource

```bash
terraform state show aws_s3_bucket.terraform_bucket
```

This displays detailed information Terraform knows about the bucket.

---

## Inspect EC2 Resource

```bash
terraform state show aws_instance.web
```

This displays detailed information about the EC2 instance.

---

# 📋 What Does the State File Contain?

Terraform state can contain information such as:

* Resource IDs
* Resource attributes
* Provider information
* Resource relationships
* Current infrastructure metadata
* Information Terraform needs to compare desired and existing infrastructure

The state allows Terraform to understand what it manages and calculate future changes.

---

# ⚠️ Why Shouldn't I Manually Edit the State File?

The state file is maintained by Terraform.

Manually changing it can:

* Break Terraform's understanding of the infrastructure
* Cause incorrect plans
* Create state inconsistencies
* Potentially result in unexpected infrastructure changes

Terraform provides state commands for controlled state management instead.

---

# 🔐 Why Shouldn't State Be Committed to Git?

Terraform state can contain sensitive infrastructure information and resource details.

Therefore, I should avoid committing `terraform.tfstate` to a public Git repository.

My `.gitignore` includes:

```gitignore
*.tfstate
*.tfstate.backup
.terraform/
```

For production environments, remote state with appropriate access controls and locking is generally preferred.

---

# ✏️ Modifying Infrastructure

I changed the EC2 tag:

```hcl
Name = "TerraWeek-Modified"
```

Then ran:

```bash
terraform plan
```

Terraform showed the proposed change before applying it.

---

## Terraform Plan Symbols

| Symbol | Meaning                                  |
| ------ | ---------------------------------------- |
| `+`    | Resource will be created                 |
| `~`    | Resource will be modified                |
| `-`    | Resource will be destroyed               |
| `-/+`  | Resource will be destroyed and recreated |

In this case, changing the EC2 Name tag resulted in an **in-place update**, represented by:

```text
~
```

Terraform did not need to destroy and recreate the instance just to change the tag.

---

## Apply the Modification

```bash
terraform apply
```

After confirmation, the EC2 instance tag was updated.

---

# 💥 Destroying the Infrastructure

After completing the experiment, I removed the infrastructure using:

```bash
terraform destroy
```

Terraform displayed the resources that would be deleted and asked for confirmation.

After confirming, Terraform destroyed the resources it was managing.

This demonstrated one of the major advantages of IaC: infrastructure can be created and removed consistently through code.

---

# 📚 Terraform Commands Learned

| Command                | Purpose                                                  |
| ---------------------- | -------------------------------------------------------- |
| `terraform init`       | Initializes the project and downloads required providers |
| `terraform fmt`        | Formats Terraform files                                  |
| `terraform validate`   | Validates Terraform configuration                        |
| `terraform plan`       | Previews infrastructure changes                          |
| `terraform apply`      | Creates or modifies infrastructure                       |
| `terraform destroy`    | Removes managed infrastructure                           |
| `terraform show`       | Displays current state in readable form                  |
| `terraform state list` | Lists Terraform-managed resources                        |
| `terraform state show` | Displays detailed resource state                         |

---

# 🎯 Day 61 Takeaways

Today I learned:

* What Infrastructure as Code means
* Why IaC is important in DevOps
* How Terraform works
* Terraform's declarative approach
* How Terraform can work across different platforms
* How to configure the AWS provider
* How to create an S3 bucket using Terraform
* How to provision an EC2 instance
* How Terraform state works
* How Terraform detects infrastructure changes
* How to modify resources safely using `terraform plan`
* How to destroy infrastructure using Terraform

---

## 🚀 Final Thoughts

Day 61 was my first real step into **Infrastructure as Code**.

Creating an S3 bucket and EC2 instance from a `.tf` file instead of manually clicking through the AWS Console made the concept of IaC much clearer.

The biggest takeaway for me is that infrastructure can be treated like code — **written, reviewed, versioned, automated, and reproducible.**

Next step: going deeper into Terraform resources, variables, outputs, and reusable configurations.

---

**#90DaysOfDevOps #TerraWeek #DevOpsKaJosh #TrainWithShubham #Terraform #AWS #DevOps #IaC #CloudComputing**

