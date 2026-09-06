# Day 67 — TerraWeek Capstone

## Objective

Build a multi-environment AWS infrastructure using Terraform custom modules and workspaces.

The project uses one Terraform codebase to manage three isolated environments:

* Development
* Staging
* Production

Each environment contains its own VPC, public subnet, security group, and EC2 instance.

---

## Project Structure

```text
terraweek-capstone/
├── main.tf
├── variables.tf
├── outputs.tf
├── providers.tf
├── locals.tf
├── dev.tfvars
├── staging.tfvars
├── prod.tfvars
├── .gitignore
├── day-67-terraweek-capstone.md
└── modules/
    ├── vpc/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── security-group/
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── ec2-instance/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Terraform Modules

### VPC Module

The VPC module creates:

* VPC
* Public subnet
* Internet Gateway
* Route table
* Route table association

It outputs the VPC ID and subnet ID.

### Security Group Module

The security group module creates a security group and dynamically creates ingress rules based on the environment's allowed ports.

### EC2 Module

The EC2 module creates an EC2 instance using the selected AMI, instance type, subnet, and security group.

---

## Terraform Workspaces

The project uses three Terraform workspaces:

```text
dev
staging
prod
```

The current environment is obtained using:

```hcl
terraform.workspace
```

For example:

```text
terraform.workspace = dev
```

when the `dev` workspace is selected.

Each workspace maintains separate Terraform state.

---

## Environment Configuration

| Environment | VPC CIDR    | Subnet CIDR | Instance Type | Ports       |
| ----------- | ----------- | ----------- | ------------- | ----------- |
| Dev         | 10.0.0.0/16 | 10.0.1.0/24 | t2.micro      | 22, 80      |
| Staging     | 10.1.0.0/16 | 10.1.1.0/24 | t2.small      | 22, 80, 443 |
| Prod        | 10.2.0.0/16 | 10.2.1.0/24 | t3.small      | 80, 443     |

The environments use different CIDR ranges to avoid network overlap.

Production does not expose SSH port 22, unlike development and staging.

---

## Deployment Commands

### Development

```bash
terraform workspace select dev
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
terraform output
```

### Staging

```bash
terraform workspace select staging
terraform plan -var-file="staging.tfvars"
terraform apply -var-file="staging.tfvars"
terraform output
```

### Production

```bash
terraform workspace select prod
terraform plan -var-file="prod.tfvars"
terraform apply -var-file="prod.tfvars"
terraform output
```

---

## Verification

The following were verified:

* Three separate Terraform workspaces
* Three separate VPCs
* Different VPC CIDR ranges
* Separate subnets
* Separate security groups
* Three EC2 instances
* Different instance sizes
* Environment-specific resource names
* Workspace-specific Terraform state
* Environment-specific security rules

---

## Terraform Best Practices Learned

### 1. File Structure

Terraform configuration is separated into providers, variables, outputs, locals, resources, and modules.

### 2. State Management

Terraform state should be stored in a secure remote backend with locking and versioning for team environments.

### 3. Variables

Environment-specific values are provided through `.tfvars` files instead of hardcoding values into resources.

### 4. Modules

Each custom module has a single responsibility and clearly defined inputs and outputs.

### 5. Workspaces

Terraform workspaces allow the same configuration to manage multiple isolated environments.

### 6. Security

Terraform state and environment variable files should not be committed to Git.

### 7. Terraform Workflow

The recommended workflow is:

```text
terraform fmt
terraform validate
terraform plan
terraform apply
```

### 8. Tagging

Resources are tagged with project, environment, and management information.

### 9. Naming

Resources follow the naming convention:

```text
<project>-<environment>-<resource>
```

Example:

```text
terraweek-prod-server
```

### 10. Cleanup

Temporary environments should be destroyed when no longer required to avoid unnecessary AWS costs.

---

## TerraWeek Summary

| Day | Concepts                                               |
| --- | ------------------------------------------------------ |
| 61  | IaC, HCL, init/plan/apply/destroy, state basics        |
| 62  | Providers, resources, dependencies, lifecycle          |
| 63  | Variables, outputs, data sources, locals, functions    |
| 64  | Remote backend, locking, import, drift                 |
| 65  | Custom modules, registry modules, versioning           |
| 66  | EKS with modules, real-world provisioning              |
| 67  | Workspaces, multi-environment infrastructure, capstone |

---

## Screenshots (All screenshots is in a folder)

### AWS VPCs

*Add screenshot showing dev, staging, and prod VPCs.*

### EC2 Instances

*Add screenshot showing all three EC2 instances.*

### Dev Terraform Output

*Add screenshot.*

### Staging Terraform Output

*Add screenshot.*

### Prod Terraform Output

*Add screenshot.*

---

## Cleanup

All environments were destroyed after verification:

```bash
terraform workspace select prod
terraform destroy -var-file="prod.tfvars"

terraform workspace select staging
terraform destroy -var-file="staging.tfvars"

terraform workspace select dev
terraform destroy -var-file="dev.tfvars"
```

Workspaces were then deleted:

```bash
terraform workspace select default

terraform workspace delete dev
terraform workspace delete staging
terraform workspace delete prod
```

The AWS account was verified to ensure that the resources created for this project were removed.

## Conclusion

Day 67 completed the TerraWeek Terraform capstone by combining Terraform workspaces, custom modules, variables, outputs, dependencies, tagging, and AWS infrastructure provisioning into a single reusable multi-environment project.
