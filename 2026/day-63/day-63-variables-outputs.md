# Day 63 – Variables, Outputs, Data Sources & Expressions

## 📌 Overview

Day 63 of my **90 Days of DevOps** journey focused on making Terraform configurations dynamic, reusable, and environment-aware.

In Day 62, the AWS infrastructure contained several hardcoded values such as the AWS region, CIDR blocks, instance type, AMI ID, and resource names.

Today, I refactored the configuration using:

* Terraform Variables
* `.tfvars` files
* Variable precedence
* Outputs
* Data Sources
* Locals
* Built-in Functions
* Conditional Expressions
* Dynamic Security Group Rules

The goal was to create Terraform infrastructure that can be reused across different environments without modifying the main configuration.

---

## 📁 Project Structure

```text
day-63/
├── main.tf
├── variables.tf
├── outputs.tf
├── data.tf
├── locals.tf
├── terraform.tfvars
├── prod.tfvars
└── day-63-variables-outputs.md
```

---

# 1. Terraform Variables

Created `variables.tf` to remove hardcoded configuration values.

```hcl
variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "allowed_ports" {
  description = "Allowed inbound ports"
  type        = list(number)
  default     = [22, 80, 443]
}

variable "extra_tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}
```

## Terraform Variable Types

| Type     | Description          | Example                 |
| -------- | -------------------- | ----------------------- |
| `string` | Text value           | `"dev"`                 |
| `number` | Numeric value        | `2`                     |
| `bool`   | Boolean value        | `true`                  |
| `list`   | Ordered collection   | `[22, 80, 443]`         |
| `map`    | Key-value collection | `{Environment = "dev"}` |

---

# 2. Variable Files

## terraform.tfvars

Terraform automatically loads `terraform.tfvars`.

```hcl
project_name  = "terraweek"
environment   = "dev"
instance_type = "t2.micro"
```

Run:

```bash
terraform plan
```

---

## prod.tfvars

Production-specific values were stored separately.

```hcl
project_name  = "terraweek"
environment   = "prod"
instance_type = "t3.small"
vpc_cidr      = "10.1.0.0/16"
subnet_cidr   = "10.1.1.0/24"
```

Use it with:

```bash
terraform plan -var-file="prod.tfvars"
```

This allows the same Terraform configuration to be used for different environments.

---

# 3. Variable Precedence

Variable values can come from several sources.

The general order from lowest to highest priority is:

```text
Variable default
        ↓
terraform.tfvars
        ↓
*.auto.tfvars
        ↓
-var-file
        ↓
-var
        ↓
TF_VAR_* environment variable
```

For example:

```bash
terraform plan -var="instance_type=t2.nano"
```

can override a lower-priority value.

Environment variables can be supplied using:

```bash
export TF_VAR_environment="staging"
```

On PowerShell:

```powershell
$env:TF_VAR_environment="staging"
```

---

# 4. Terraform Outputs

Created `outputs.tf` to expose important infrastructure information.

Outputs include:

* VPC ID
* Subnet ID
* EC2 Instance ID
* EC2 Public IP
* EC2 Public DNS
* Security Group ID

Example:

```hcl
output "vpc_id" {
  value = aws_vpc.main.id
}

output "instance_public_ip" {
  value = aws_instance.server.public_ip
}
```

After applying:

```bash
terraform apply
```

all outputs are displayed.

Individual outputs can be viewed with:

```bash
terraform output
```

```bash
terraform output instance_public_ip
```

JSON output:

```bash
terraform output -json
```

---

# 5. Data Sources

Instead of hardcoding an AMI ID, I used an AWS data source to dynamically find an Amazon Linux AMI.

```hcl
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
```

The EC2 instance then uses:

```hcl
ami = data.aws_ami.amazon_linux.id
```

I also used:

```hcl
data "aws_availability_zones" "available" {
  state = "available"
}
```

and selected the first available AZ:

```hcl
availability_zone = data.aws_availability_zones.available.names[0]
```

## Resource vs Data Source

A Terraform **resource** creates or manages infrastructure.

```hcl
resource "aws_vpc" "main" {
  ...
}
```

A Terraform **data source** reads information about existing infrastructure or external resources.

```hcl
data "aws_ami" "amazon_linux" {
  ...
}
```

In simple terms:

```text
resource = create/manage

data = read/fetch
```

---

# 6. Locals

Created reusable local values:

```hcl
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}
```

This creates consistent resource naming.

For example:

```text
terraweek-dev-vpc
terraweek-dev-subnet
terraweek-dev-server
```

For production:

```text
terraweek-prod-vpc
terraweek-prod-subnet
terraweek-prod-server
```

Tags can be combined using:

```hcl
tags = merge(local.common_tags, {
  Name = "${local.name_prefix}-server"
})
```

---

# 7. Conditional Expressions

I used a conditional expression for environment-specific EC2 sizing.

```hcl
instance_type = var.environment == "prod" ? "t3.small" : var.instance_type
```

The expression means:

```text
If environment is prod
        ↓
Use t3.small

Otherwise
        ↓
Use the configured instance type
```

Therefore:

```text
dev  → t2.micro
prod → t3.small
```

---

# 8. Terraform Console

Terraform's interactive console was used to test expressions and functions.

Start it with:

```bash
terraform console
```

Examples:

```hcl
upper("terraweek")
```

```text
"TERRAWEEK"
```

```hcl
join("-", ["terra", "week", "2026"])
```

```text
"terra-week-2026"
```

```hcl
length(["a", "b", "c"])
```

```text
3
```

```hcl
lookup({dev = "t2.micro", prod = "t3.small"}, "dev")
```

```text
"t2.micro"
```

```hcl
cidrsubnet("10.0.0.0/16", 8, 1)
```

```text
"10.0.1.0/24"
```

---

# 9. Five Useful Terraform Functions

## 1. merge()

Combines maps together.

```hcl
merge(
  {Environment = "dev"},
  {Project = "terraweek"}
)
```

Useful for combining resource tags.

## 2. lookup()

Retrieves a value from a map.

```hcl
lookup(
  {dev = "t2.micro", prod = "t3.small"},
  "prod"
)
```

Returns:

```text
t3.small
```

## 3. join()

Combines list elements into a string.

```hcl
join("-", ["terra", "week", "2026"])
```

Returns:

```text
terra-week-2026
```

## 4. length()

Returns the number of elements in a collection.

```hcl
length(["a", "b", "c"])
```

Returns:

```text
3
```

## 5. cidrsubnet()

Calculates subnet CIDR ranges.

```hcl
cidrsubnet("10.0.0.0/16", 8, 1)
```

Returns:

```text
10.0.1.0/24
```

---

# 10. Variable vs Local vs Output vs Data

| Terraform Feature | Purpose                              |
| ----------------- | ------------------------------------ |
| `variable`        | Accepts input values                 |
| `local`           | Stores reusable calculated values    |
| `output`          | Displays or exposes Terraform values |
| `data`            | Reads existing information           |

A simple mental model:

```text
variable
   ↓
local
   ↓
resource / data
   ↓
output
```

---

# 11. Terraform Commands Used

Initialize:

```bash
terraform init
```

Format:

```bash
terraform fmt
```

Validate:

```bash
terraform validate
```

Create execution plan:

```bash
terraform plan
```

Use production variables:

```bash
terraform plan -var-file="prod.tfvars"
```

Apply:

```bash
terraform apply
```

View outputs:

```bash
terraform output
```

Open console:

```bash
terraform console
```

Destroy resources:

```bash
terraform destroy
```

---

# 12. Verification

After `terraform apply`, I verified that:

* Terraform accepted variable values.
* The infrastructure was created successfully.
* The AMI was fetched dynamically.
* The availability zone was discovered dynamically.
* Resource names were generated using locals.
* Common tags were applied consistently.
* Production uses the environment-specific instance type.
* Terraform outputs display the infrastructure IDs and EC2 public IP.
* `terraform output instance_public_ip` returns the EC2 public IP.

### Output Screenshot

*Add the screenshot of your successful `terraform apply` output here.*

```text
![Terraform Apply Outputs](./terraform-output.png)
```

---

# 13. Key Learnings

### Before Day 63

```text
Hardcoded values
      ↓
Less reusable
      ↓
Difficult to maintain
```

### After Day 63

```text
Variables
      ↓
.tfvars
      ↓
Locals
      ↓
Data Sources
      ↓
Expressions
      ↓
Reusable Infrastructure
```

The biggest lesson from Day 63 is that Terraform configurations should not be written only to work once. They should be designed to be **reusable, dynamic, maintainable, and environment-aware**.

---

## 🚀 Day 63 Completed

**Topics covered:**

* ✅ Terraform Variables
* ✅ Variable Types
* ✅ `.tfvars` Files
* ✅ Variable Precedence
* ✅ Terraform Outputs
* ✅ AWS Data Sources
* ✅ Locals
* ✅ Dynamic Tags
* ✅ Built-in Functions
* ✅ Conditional Expressions
* ✅ Environment-specific Configuration
* ✅ Terraform Console
* ✅ Dynamic AMI Lookup
* ✅ Dynamic Availability Zones

**#90DaysOfDevOps #TerraWeek #DevOpsKaJosh #TrainWithShubham**
