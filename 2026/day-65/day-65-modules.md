# Day 65 – Terraform Modules: Build Reusable Infrastructure

## Overview

Today I learned how Terraform modules can be used to create reusable and maintainable Infrastructure as Code.

Instead of putting every resource into one large `main.tf`, I separated infrastructure into reusable modules.

For this project I created:

* A custom EC2 module
* A custom Security Group module
* Two EC2 instances using the same EC2 module
* A Security Group using a dynamic ingress block
* A VPC using the public Terraform Registry module
* Root-level outputs for module resources

---

# 1. Module Structure

The final project structure is:

```text
terraform-modules/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── README.md
└── modules/
    ├── ec2-instance/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── security-group/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Root Module

The root module is the main Terraform project directory.

It is responsible for:

* Calling child modules
* Passing variables to modules
* Connecting modules together
* Managing the overall infrastructure

## Child Module

A child module is a reusable Terraform configuration stored in a separate directory.

In this project:

```text
modules/ec2-instance
modules/security-group
```

The same EC2 module is called twice with different values.

---

# 2. EC2 Custom Module

The EC2 module contains three files:

```text
modules/ec2-instance/
├── main.tf
├── variables.tf
└── outputs.tf
```

## variables.tf

```hcl
variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_id" {
  description = "Subnet ID where EC2 will be launched"
  type        = string
}

variable "security_group_ids" {
  description = "Security group IDs"
  type        = list(string)
}

variable "instance_name" {
  description = "Name of the EC2 instance"
  type        = string
}

variable "tags" {
  description = "Additional resource tags"
  type        = map(string)
  default     = {}
}
```

## main.tf

```hcl
resource "aws_instance" "this" {
  ami           = var.ami_id
  instance_type = var.instance_type

  subnet_id = var.subnet_id

  vpc_security_group_ids = var.security_group_ids

  tags = merge(
    var.tags,
    {
      Name = var.instance_name
    }
  )
}
```

The module uses `merge()` to combine common tags with the instance-specific `Name` tag.

## outputs.tf

```hcl
output "instance_id" {
  description = "EC2 instance ID"
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "Public IP address"
  value       = aws_instance.this.public_ip
}

output "private_ip" {
  description = "Private IP address"
  value       = aws_instance.this.private_ip
}
```

---

# 3. Security Group Module

The Security Group module creates a reusable security group.

The important new concept is the Terraform `dynamic` block.

```hcl
dynamic "ingress" {
  for_each = var.ingress_ports

  content {
    description = "Allow port ${ingress.value}"

    from_port = ingress.value
    to_port   = ingress.value

    protocol = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }
}
```

If the input is:

```hcl
ingress_ports = [22, 80, 443]
```

Terraform creates three ingress rules.

This avoids repeating the same block manually.

---

# 4. Calling the Custom Modules

The Security Group module is called from the root module:

```hcl
module "web_sg" {
  source = "./modules/security-group"

  vpc_id = module.vpc.vpc_id

  sg_name = "terraweek-web-sg"

  ingress_ports = [
    22,
    80,
    443
  ]

  tags = local.common_tags
}
```

The EC2 module is called for the web server:

```hcl
module "web_server" {
  source = "./modules/ec2-instance"

  ami_id = data.aws_ami.amazon_linux.id

  instance_type = "t2.micro"

  subnet_id = module.vpc.public_subnets[0]

  security_group_ids = [
    module.web_sg.sg_id
  ]

  instance_name = "terraweek-web"

  tags = local.common_tags
}
```

The same module is reused for the API server:

```hcl
module "api_server" {
  source = "./modules/ec2-instance"

  ami_id = data.aws_ami.amazon_linux.id

  instance_type = "t2.micro"

  subnet_id = module.vpc.public_subnets[0]

  security_group_ids = [
    module.web_sg.sg_id
  ]

  instance_name = "terraweek-api"

  tags = local.common_tags
}
```

The module is therefore written once but used twice.

---

# 5. Public Terraform Registry Module

Instead of manually creating every VPC resource, I used the public Terraform Registry VPC module.

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"

  name = "terraweek-vpc"
  cidr = "10.0.0.0/16"

  azs = [
    "ap-south-1a",
    "ap-south-1b"
  ]

  public_subnets = [
    "10.0.1.0/24",
    "10.0.2.0/24"
  ]

  private_subnets = [
    "10.0.3.0/24",
    "10.0.4.0/24"
  ]

  enable_nat_gateway   = false
  enable_dns_hostnames = true

  tags = local.common_tags
}
```

The EC2 and Security Group modules consume outputs from the VPC module:

```hcl
module.vpc.vpc_id
```

and:

```hcl
module.vpc.public_subnets[0]
```

This demonstrates module composition.

---

# 6. Module Download Location

After running:

```bash
terraform init
```

Terraform downloads the registry module into the project's generated module directory:

```text
.terraform/modules/
```

The `.terraform` directory is Terraform's working directory and should normally not be committed to Git.

---

# 7. Terraform Execution

The main commands used were:

```bash
terraform fmt -recursive
```

Format Terraform files.

```bash
terraform init
```

Initialize Terraform and download providers/modules.

```bash
terraform validate
```

Validate the configuration.

```bash
terraform plan
```

Preview the infrastructure changes.

```bash
terraform apply
```

Create the infrastructure.

```bash
terraform output
```

Display module outputs.

```bash
terraform state list
```

Inspect resources tracked by Terraform.

```bash
terraform init -upgrade
```

Check for newer acceptable module/provider versions.

Finally:

```bash
terraform destroy
```

Remove the infrastructure.

---

# 8. Terraform State and Modules

After applying the configuration, resources appear in the Terraform state using module prefixes.

Examples:

```text
module.web_server.aws_instance.this
module.api_server.aws_instance.this
module.web_sg.aws_security_group.this
module.vpc.aws_subnet.public[0]
```

The module prefix tells Terraform which module instance owns the resource.

This allows the same child module to create multiple independent resources.

---

# 9. EC2 Verification

Two EC2 instances were created using the same custom module:

| Name          | Module       | Type     | Security Group   |
| ------------- | ------------ | -------- | ---------------- |
| terraweek-web | ec2-instance | t2.micro | terraweek-web-sg |
| terraweek-api | ec2-instance | t2.micro | terraweek-web-sg |

Both instances use the same reusable EC2 module but receive different names.

### AWS Console Screenshot

> Add your screenshot here after applying the infrastructure.

```text
![Two EC2 instances running](./screenshots/ec2-instances.png)
```

---

# 10. VPC Module Comparison

## Day 62 – Hand-Written VPC

In Day 62, networking resources were written individually, including:

* VPC
* Subnets
* Internet Gateway
* Route Table
* Routes
* Route Table Associations
* Security Group

## Day 65 – Registry Module

The VPC configuration is now represented by:

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.0"
  ...
}
```

The registry module hides the implementation details and exposes useful outputs.

### Resource Count

Run:

```bash
terraform state list | grep "module.vpc"
```

or on PowerShell:

```powershell
terraform state list | Select-String "module.vpc"
```

Record the actual number of resources created by the VPC module here:

```text
VPC Registry Module Resources: ______
```

For an accurate comparison, compare this with the resources tracked by the Day 62 VPC configuration rather than assuming a fixed number.

---

# 11. Five Terraform Module Best Practices

## 1. Pin Module Versions

Use a specific version for production workloads.

Example:

```hcl
version = "5.1.0"
```

This prevents unexpected module changes from affecting infrastructure.

## 2. Keep Modules Focused

A module should have a clear responsibility.

For example:

```text
ec2-instance → EC2 infrastructure
security-group → Security group infrastructure
```

Avoid creating one giant module that manages everything.

## 3. Use Variables

Instead of hardcoding values, expose them as variables.

For example:

```hcl
variable "instance_type" {
  type    = string
  default = "t2.micro"
}
```

This makes the module reusable in different environments.

## 4. Define Outputs

Outputs allow the parent module to consume important resource information.

For example:

```hcl
output "instance_id" {
  value = aws_instance.this.id
}
```

The root module can then use:

```hcl
module.web_server.instance_id
```

## 5. Document Custom Modules

Every reusable module should contain documentation explaining:

* What the module creates
* Required variables
* Optional variables
* Outputs
* Example usage
* Important requirements

Good documentation makes modules easier for other engineers to reuse.

---

# 12. What I Learned

Day 65 helped me understand that Terraform modules are similar to reusable functions in programming.

The biggest concepts I learned were:

```text
Root Module
     ↓
Child Modules
     ↓
Variables → Module Inputs
     ↓
Resources
     ↓
Outputs → Module Results
```

I also learned how registry modules can significantly simplify infrastructure code.

Instead of manually managing every VPC component, I can consume a well-tested public module and focus on how my application infrastructure uses the network.

---

# 13. Final Cleanup

After verification:

```bash
terraform destroy
```

Then verify:

```bash
terraform state list
```

The infrastructure should be removed from AWS and the Terraform state should no longer contain the deployed resources.

---

# Conclusion

Terraform modules make Infrastructure as Code more reusable, maintainable, and scalable.

Instead of copying the same infrastructure configuration between environments, I can create a module once and reuse it with different inputs.

Day 65 introduced me to:

* Custom modules
* Module inputs
* Module outputs
* Dynamic blocks
* Module composition
* Registry modules
* Module versioning
* Terraform module state
* Infrastructure reuse
