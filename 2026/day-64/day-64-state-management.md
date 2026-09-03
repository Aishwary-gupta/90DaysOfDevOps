# Day 64 — Terraform State Management and Remote Backends

## 🎯 Objective

Today I learned how Terraform manages infrastructure state and how to safely manage state in a team environment.

### Topics Covered

* Terraform state inspection
* Remote S3 backend
* State versioning
* DynamoDB state locking
* Terraform import
* `terraform state mv`
* `terraform state rm`
* State drift detection and reconciliation

---

## 🏗️ Architecture

```text
Terraform Configuration
        |
        v
    Terraform
        |
   +----+----+
   |         |
   v         v
  S3      DynamoDB
State     Locking
   |
   v
AWS Infrastructure
```

---

## 1. Inspecting Terraform State

I first applied my Terraform configuration and inspected the state using:

```bash
terraform show
terraform state list
terraform state show aws_instance.web
terraform state show aws_vpc.main
```

The `terraform.tfstate` file contains the mapping between my Terraform configuration and the real AWS infrastructure.

The state stores many attributes discovered from AWS, including IDs, IP addresses, availability zones, subnet IDs, security groups, instance type, tags, and other resource information.

The `serial` value represents the state revision and changes as the state is updated.

---

## 2. S3 Remote Backend

I created an S3 bucket for remote Terraform state and enabled versioning.

```bash
aws s3api create-bucket \
  --bucket terraweek-state-<yourname> \
  --region ap-south-1 \
  --create-bucket-configuration LocationConstraint=ap-south-1
```

Versioning was enabled so previous versions of the state can be recovered.

I then configured the S3 backend:

```hcl
backend "s3" {
  bucket         = "terraweek-state-<yourname>"
  key            = "dev/terraform.tfstate"
  region         = "ap-south-1"
  dynamodb_table = "terraweek-state-lock"
  encrypt        = true
}
```

Then I migrated the local state:

```bash
terraform init -migrate-state
```

After migration, I verified the state in S3 and ran:

```bash
terraform plan
```

The expected result was:

```text
No changes.
```

---

## 3. State Locking

I configured DynamoDB for Terraform state locking.

The table uses:

```text
LockID
```

as its string partition key.

State locking prevents multiple Terraform operations from modifying the same state simultaneously.

During the locking test, I used two terminals and attempted to run Terraform operations at the same time.

**Lock error screenshot:**
*Add screenshot here.*

---

## 4. Importing an Existing Resource

I manually created an S3 bucket in AWS and added the following Terraform resource:

```hcl
resource "aws_s3_bucket" "imported" {
  bucket = "terraweek-import-test-<yourname>"
}
```

I imported the existing bucket using:

```bash
terraform import \
  aws_s3_bucket.imported \
  terraweek-import-test-<yourname>
```

Then I verified:

```bash
terraform state list
terraform state show aws_s3_bucket.imported
terraform plan
```

The import brought the existing AWS resource under Terraform state management without creating a new bucket.

**Import screenshot:**
*Add screenshot here.*

---

## 5. State Surgery

### `terraform state mv`

Used to change a Terraform resource address without destroying the real AWS resource.

```bash
terraform state mv \
  aws_s3_bucket.imported \
  aws_s3_bucket.logs_bucket
```

Useful when renaming resources or restructuring Terraform modules.

### `terraform state rm`

Used to remove a resource from Terraform state without deleting the actual AWS resource.

```bash
terraform state rm aws_s3_bucket.logs_bucket
```

The resource can later be imported again.

---

## 6. State Drift

I simulated drift by manually changing the EC2 Name tag in AWS.

Terraform configuration expected:

```text
WebServer
```

I manually changed it to:

```text
ManuallyChanged
```

Then:

```bash
terraform plan
```

detected the difference between the desired configuration and the actual AWS infrastructure.

I reconciled the drift using:

```bash
terraform apply
```

Finally:

```bash
terraform plan
```

returned:

```text
No changes.
```

**Drift screenshot:**
*Add screenshot here.*

---

## 📚 Important Commands

| Command                         | Purpose                                      |
| ------------------------------- | -------------------------------------------- |
| `terraform show`                | View state                                   |
| `terraform state list`          | List resources                               |
| `terraform state show`          | Inspect a resource                           |
| `terraform import`              | Import existing resource                     |
| `terraform state mv`            | Move resource address                        |
| `terraform state rm`            | Remove resource from state                   |
| `terraform force-unlock`        | Remove stale lock                            |
| `terraform apply -refresh-only` | Refresh state without infrastructure changes |
| `terraform plan`                | Detect changes                               |
| `terraform init -migrate-state` | Migrate state backend                        |

---

## ✅ Day 64 Result

By completing this task, I learned how to:

* Inspect Terraform state
* Store state remotely in S3
* Enable state versioning
* Use state locking
* Import existing AWS resources
* Perform state surgery
* Detect infrastructure drift
* Reconcile drift using Terraform

Terraform state is a critical part of Infrastructure as Code because it maintains the relationship between Terraform configuration and real infrastructure.
