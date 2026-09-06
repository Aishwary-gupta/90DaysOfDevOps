# Day 66 — Provision an EKS Cluster with Terraform Modules

## 📌 Objective

The goal of Day 66 was to provision a complete AWS EKS cluster using Terraform Registry modules.

Instead of manually creating the Kubernetes infrastructure, I used Terraform to automate:

* AWS VPC
* Public and private subnets
* Internet Gateway
* NAT Gateway
* EKS cluster
* IAM roles
* Security groups
* EKS managed node group
* Kubernetes worker nodes

After provisioning the cluster, I connected it with `kubectl`, deployed an Nginx workload, exposed it using an AWS LoadBalancer, verified the application, and finally destroyed all resources.

---

## 🏗️ Project Structure

```text
2026/day-66/
│
├── day-66-eks-terraform.md
│
└── terraform-eks/
    ├── providers.tf
    ├── vpc.tf
    ├── eks.tf
    ├── variables.tf
    ├── outputs.tf
    ├── terraform.tfvars
    │
    └── k8s/
        └── nginx-deployment.yaml
```

---

## 🔧 Technologies Used

* Terraform
* AWS
* Amazon EKS
* Amazon VPC
* EC2
* IAM
* Kubernetes
* kubectl
* Nginx
* Terraform Registry Modules

---

# 1. Terraform Providers

The AWS provider was pinned to the 5.x release family and the Kubernetes provider was also defined for later Kubernetes integration.

```hcl
terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.30"
    }
  }
}

provider "aws" {
  region = var.region
}
```

---

# 2. VPC Module

I used the `terraform-aws-modules/vpc/aws` Registry module to create the networking infrastructure.

The VPC contains:

* 2 Availability Zones
* 2 public subnets
* 2 private subnets
* 1 NAT Gateway
* Internet Gateway
* Route tables
* DNS hostnames

The VPC CIDR was:

```text
10.0.0.0/16
```

The subnets were tagged for Kubernetes load balancer discovery.

Public subnets:

```hcl
public_subnet_tags = {
  "kubernetes.io/role/elb" = 1
}
```

Private subnets:

```hcl
private_subnet_tags = {
  "kubernetes.io/role/internal-elb" = 1
}
```

### Why public and private subnets?

Public subnets provide internet-facing networking for resources such as load balancers.

Private subnets are used for EKS worker nodes so that the nodes do not need public IP addresses.

The NAT Gateway allows resources in private subnets to access the internet for outbound traffic.

Using two Availability Zones also improves availability.

---

# 3. EKS Module

The EKS cluster was created using:

```hcl
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
}
```

The cluster was configured with:

```text
Cluster Name: terraweek-eks
Kubernetes Version: 1.31
Node Instance Type: t3.medium
Desired Nodes: 2
```

The managed node group configuration used:

```hcl
eks_managed_node_groups = {
  terraweek_nodes = {
    ami_type       = "AL2_x86_64"
    instance_types = [var.node_instance_type]

    min_size     = 1
    max_size     = 3
    desired_size = var.node_desired_count
  }
}
```

Terraform automatically created the supporting IAM roles, security groups, EKS control plane resources, and managed node group resources.

---

# 4. Terraform Initialization

The project was initialized using:

```bash
terraform init
```

Then the configuration was validated:

```bash
terraform validate
```

Finally, I reviewed the infrastructure plan:

```bash
terraform plan
```

---

# 5. Terraform Apply

The infrastructure was provisioned using:

```bash
terraform apply
```

Terraform created the complete AWS infrastructure required for the EKS cluster.

### Apply Result

```text
Apply complete! Resources: XX added, 0 changed, 0 destroyed.
```

> Replace `XX` with the actual number shown in your Terraform output.

<!-- ### 📸 Screenshot

Add your `terraform apply` completion screenshot here. -->

---

# 6. Connect kubectl to EKS

After the cluster was created, I updated the local Kubernetes configuration:

```bash
aws eks update-kubeconfig \
  --name terraweek-eks \
  --region ap-south-1
```

I verified the active context using:

```bash
kubectl config current-context
```

---

# 7. Verify EKS Nodes

The worker nodes were checked using:

```bash
kubectl get nodes
```

The expected result was two nodes in the `Ready` state.

Example:

```text
NAME                          STATUS   ROLES    AGE   VERSION
ip-10-0-11-xxx.ec2.internal   Ready    <none>   ...   v1.31.x
ip-10-0-12-xxx.ec2.internal   Ready    <none>   ...   v1.31.x
```

<!-- ### 📸 Screenshot

Add the `kubectl get nodes` screenshot here. -->

---

# 8. Verify Kubernetes System Pods

I checked the Kubernetes system components using:

```bash
kubectl get pods -A
```

I also verified the cluster using:

```bash
kubectl cluster-info
```

This confirmed that the EKS control plane and Kubernetes system workloads were running.

---

# 9. Deploy Nginx

I created:

```text
k8s/nginx-deployment.yaml
```

The manifest creates:

* Nginx Deployment
* 3 Nginx replicas
* LoadBalancer Service

The deployment was applied using:

```bash
kubectl apply -f k8s/nginx-deployment.yaml
```

---

# 10. Verify Nginx Pods

I checked the deployment:

```bash
kubectl get deployments
```

Then checked the pods:

```bash
kubectl get pods
```

Three Nginx replicas were expected to reach the `Running` state.

Example:

```text
NAME                               READY   STATUS
nginx-terraweek-xxxxxxxxxx-xxxxx   1/1     Running
nginx-terraweek-xxxxxxxxxx-xxxxx   1/1     Running
nginx-terraweek-xxxxxxxxxx-xxxxx   1/1     Running
```

### 📸 Screenshot

Add the Nginx pods screenshot here.

---

# 11. Expose Nginx with LoadBalancer

The Nginx service was configured as:

```yaml
type: LoadBalancer
```

I checked the service using:

```bash
kubectl get svc nginx-service
```

The external address initially appeared as:

```text
<pending>
```

After AWS provisioned the load balancer, an external hostname became available.

I also used:

```bash
kubectl get svc nginx-service -w
```

to monitor the service.

---

# 12. Test the Nginx Application

After the AWS LoadBalancer became available, I opened the external address in a web browser.

The Nginx welcome page was displayed successfully.

### 📸 Screenshot

Add the browser screenshot showing the Nginx welcome page here.

---

# 13. Final Kubernetes Verification

The complete Kubernetes environment was verified using:

```bash
kubectl get nodes
kubectl get deployments
kubectl get pods
kubectl get svc
```

This confirmed:

* 2 EKS worker nodes
* 3 Nginx replicas
* Nginx Service
* AWS LoadBalancer
* Running Kubernetes workloads

---

# 14. Destroy the Kubernetes Workload

Before destroying the AWS infrastructure, I removed the Kubernetes resources:

```bash
kubectl delete -f k8s/nginx-deployment.yaml
```

This was important because the LoadBalancer Service created an AWS load balancer.

Removing it first allowed AWS to clean up the load balancer before deleting the VPC infrastructure.

---

# 15. Terraform Destroy

After confirming that the LoadBalancer was removed, I destroyed the Terraform-managed infrastructure:

```bash
terraform destroy
```

I confirmed the operation by entering:

```text
yes
```

### Destroy Result

```text
Destroy complete! Resources: XX destroyed.
```

> Replace `XX` with the actual number from your output.

<!-- ### 📸 Screenshot

Add your `terraform destroy` completion screenshot here.

--- -->

# 16. AWS Cleanup Verification

I verified the AWS console and confirmed that the following resources were removed:

* EKS cluster
* EKS worker node instances
* VPC
* Subnets
* NAT Gateway
* Elastic IP
* Internet Gateway
* Load Balancer
* Related networking resources

The AWS environment was successfully cleaned up.

---

# 17. Terraform Commands Used

```bash
terraform init
terraform validate
terraform plan
terraform apply
terraform output
terraform destroy
```

Kubernetes commands:

```bash
kubectl get nodes
kubectl get pods -A
kubectl cluster-info
kubectl apply -f k8s/nginx-deployment.yaml
kubectl get deployments
kubectl get pods
kubectl get svc
kubectl delete -f k8s/nginx-deployment.yaml
```

AWS command:

```bash
aws eks update-kubeconfig \
  --name terraweek-eks \
  --region ap-south-1
```

---

# 18. Terraform Modules vs Manual Kubernetes Setup

Previously, Kubernetes clusters could be created locally using tools such as kind or Minikube.

Those environments are excellent for learning Kubernetes concepts because they are lightweight and run locally.

This EKS exercise was different because the entire infrastructure was created in AWS using Terraform.

### kind / Minikube

```text
Local Machine
     │
     ▼
Kubernetes Cluster
     │
     ▼
Pods
```

### Terraform + EKS

```text
Terraform
    │
    ├── VPC
    ├── Subnets
    ├── NAT Gateway
    ├── IAM
    ├── EKS
    ├── Node Group
    └── Security Groups
             │
             ▼
         EKS Cluster
             │
             ▼
          Nginx
```

The major advantage of Terraform is repeatability.

The same infrastructure can be recreated using the same configuration instead of manually repeating dozens of AWS console operations.

---

# 19. Key Learnings

### Terraform Modules

Modules allow complex infrastructure to be packaged and reused.

### AWS EKS

EKS provides a managed Kubernetes control plane on AWS.

### Managed Node Groups

AWS manages the lifecycle of the worker nodes while Kubernetes schedules workloads on them.

### VPC Networking

EKS requires correctly configured networking, subnets, routing, and security.

### NAT Gateway

NAT allows private subnet resources to initiate outbound internet connections.

### Kubernetes LoadBalancer

A Kubernetes `LoadBalancer` Service can provision an AWS load balancer for external access.

### Infrastructure as Code

Terraform makes infrastructure:

* Repeatable
* Version controlled
* Reviewable
* Automated
* Destroyable

---

# 20. Reflection

This exercise showed the difference between simply learning Kubernetes and managing Kubernetes infrastructure in a cloud environment.

With kind or Minikube, the cluster can be created quickly on a local machine. However, with EKS, there are many additional infrastructure components such as VPCs, subnets, IAM roles, security groups, NAT gateways, node groups, and load balancers.

Terraform modules made this process much easier by allowing the infrastructure to be defined declaratively.

The most important lesson from this exercise was that infrastructure can be created, managed, and destroyed using code instead of manually configuring every AWS resource.

This is a practical example of Infrastructure as Code and a major step toward production-oriented DevOps.

---

## ✅ Final Result

Successfully completed:

* [x] VPC created with Terraform module
* [x] Public and private subnets created
* [x] NAT Gateway configured
* [x] EKS cluster created
* [x] Managed node group created
* [x] 2 worker nodes verified
* [x] kubectl connected
* [x] Nginx deployed
* [x] 3 Nginx replicas running
* [x] AWS LoadBalancer created
* [x] Nginx accessed through LoadBalancer
* [x] Kubernetes resources deleted
* [x] Terraform infrastructure destroyed
* [x] AWS resources verified clean

**Day 66 complete — EKS provisioned using Terraform Modules! 🚀**
