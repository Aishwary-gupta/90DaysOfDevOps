# Day 50 – Kubernetes Architecture and Cluster Setup

## Overview

Today I started my Kubernetes journey as part of my **90 Days of DevOps** challenge.

Until now, I focused on Docker and containerization. Kubernetes takes the next step by providing container orchestration — helping manage containers across multiple machines, handle scheduling, networking, scaling, and maintain the desired state of applications.

For this exercise, I used **kind (Kubernetes IN Docker)** to create a local Kubernetes cluster and explored the Kubernetes control plane, worker node components, namespaces, Pods, contexts, and kubeconfig.

---

## 1. Kubernetes History

Kubernetes was originally created by engineers at Google and was inspired by Google's internal container orchestration system called Borg. It was designed to solve the challenges of managing containers at large scale. Kubernetes later became an open-source project and was donated to the Cloud Native Computing Foundation (CNCF). The name Kubernetes comes from Greek and refers to a helmsman or ship captain, which represents its role in steering and coordinating containerized workloads.

---

## 2. Why Kubernetes?

Docker is excellent for building and running containers, but managing hundreds or thousands of containers across multiple machines becomes difficult manually.

Kubernetes provides capabilities such as:

* Container orchestration
* Scheduling
* Scaling
* Self-healing
* Service discovery
* Networking
* Rolling updates
* Desired-state management

A simple way to remember it:

```text
Docker
   ↓
Runs containers

Kubernetes
   ↓
Orchestrates containers
```

---

## 3. Kubernetes Architecture

```text
                         Kubernetes Cluster
                                │
                ┌───────────────┴────────────────┐
                │                                │
          CONTROL PLANE                      WORKER NODE
                │                                │
       ┌────────┼────────┐              ┌────────┼────────┐
       │        │        │              │        │        │
   API Server  etcd  Scheduler       kubelet  kube-proxy  Runtime
       │        │        │                │        │        │
       │        │        │                └────────┼────────┘
       │        │        │                         │
       │        │        │                        Pods
       │        │        │                         │
       │        │        │                    Containers
       │        │        │
       └────────┼────────┘
                │
        Controller Manager
```

---

## 4. Control Plane Components

### API Server

The API Server is the front door of the Kubernetes cluster. `kubectl` communicates with the cluster through the API Server.

### etcd

etcd is the distributed key-value store used by Kubernetes to store cluster state and configuration.

### Scheduler

The Scheduler decides which worker node should run a newly created Pod.

### Controller Manager

The Controller Manager watches the cluster and works to make the actual state match the desired state.

---

## 5. Worker Node Components

### kubelet

kubelet is the agent running on each worker node. It communicates with the Kubernetes control plane and ensures that assigned Pods are running correctly.

### kube-proxy

kube-proxy maintains node-level networking rules that help Kubernetes services communicate with Pods.

### Container Runtime

The container runtime is responsible for actually running containers. Examples include containerd and CRI-O.

---

## 6. What Happens During `kubectl apply`?

When I run:

```bash
kubectl apply -f pod.yaml
```

the request follows approximately this flow:

```text
kubectl
   ↓
API Server
   ↓
etcd
   ↓
Scheduler
   ↓
Worker Node
   ↓
kubelet
   ↓
Container Runtime
   ↓
Pod
   ↓
Container
```

The API Server receives the request, the desired state is stored, the Scheduler selects a suitable node, and kubelet works with the container runtime to start the workload.

---

## 7. Tool Selected: kind

I chose **kind (Kubernetes IN Docker)** because I am already familiar with Docker.

kind creates Kubernetes nodes using Docker containers, making it lightweight and convenient for local Kubernetes learning and testing.

---

## 8. kubectl Installation

I verified the Kubernetes CLI using:

```bash
kubectl version --client
```

`kubectl` is the command-line interface used to communicate with Kubernetes clusters.

---

## 9. Cluster Creation

I created my local Kubernetes cluster using:

```bash
kind create cluster --name devops-cluster
```

Then I verified the cluster:

```bash
kubectl cluster-info
```

---

## 10. Verify Nodes

Command:

```bash
kubectl get nodes
```

Expected result:

```text
NAME                         STATUS   ROLES           AGE   VERSION
devops-cluster-control-plane Ready    control-plane   ...   ...
```

The important result is:

```text
STATUS = Ready
```

### Screenshot

*Add screenshot of `kubectl get nodes` here.*

---

## 11. Exploring Namespaces

I listed namespaces using:

```bash
kubectl get namespaces
```

Important namespaces included:

```text
default
kube-node-lease
kube-public
kube-system
```

The `kube-system` namespace contains many Kubernetes system components.

---

## 12. Exploring All Pods

I used:

```bash
kubectl get pods -A
```

The `-A` option means:

```text
--all-namespaces
```

This displays Pods across all namespaces.

---

## 13. Kubernetes System Pods

I inspected the Kubernetes system Pods using:

```bash
kubectl get pods -n kube-system
```

Typical components include:

| Component               | Purpose                              |
| ----------------------- | ------------------------------------ |
| kube-apiserver          | Provides the Kubernetes API          |
| etcd                    | Stores cluster state                 |
| kube-scheduler          | Assigns Pods to nodes                |
| kube-controller-manager | Maintains desired state              |
| kube-proxy              | Handles node-level networking rules  |
| coredns                 | Provides DNS-based service discovery |

### Screenshot

*Add screenshot of `kubectl get pods -n kube-system` here.*

---

## 14. Node Details

I inspected detailed information about my node using:

```bash
kubectl describe node <node-name>
```

This provides information about:

* CPU
* Memory
* Conditions
* Labels
* Taints
* Pods
* Allocated resources
* Node addresses

---

## 15. Cluster Lifecycle

I practiced deleting the cluster:

```bash
kind delete cluster --name devops-cluster
```

Then recreated it:

```bash
kind create cluster --name devops-cluster
```

Finally, I verified it again:

```bash
kubectl get nodes
```

This demonstrated that a local Kubernetes environment can be recreated quickly.

---

## 16. Kubernetes Contexts

I checked my current Kubernetes context:

```bash
kubectl config current-context
```

I listed available contexts:

```bash
kubectl config get-contexts
```

A context tells kubectl which cluster and user configuration it should use.

---

## 17. Kubeconfig

The kubeconfig file contains configuration information that allows `kubectl` to communicate with Kubernetes clusters.

It contains information about:

* Clusters
* Users
* Contexts
* Current context

The default location is:

```text
~/.kube/config
```

On Windows:

```text
C:\Users\<username>\.kube\config
```

I inspected it using:

```bash
kubectl config view
```

---

## 18. Key Learnings

Today I learned:

* Why Kubernetes is needed for container orchestration
* Kubernetes history and its connection to Google's Borg
* Kubernetes architecture
* Control plane components
* Worker node components
* How `kubectl` communicates with the cluster
* How Pods are scheduled
* How kubelet manages workloads
* What etcd stores
* What namespaces are
* How to inspect Kubernetes system Pods
* How Kubernetes contexts work
* What kubeconfig is
* How to create and delete a local Kubernetes cluster using kind

---

## 19. Commands Practiced

```bash
kubectl version --client
kind version

kind create cluster --name devops-cluster

kubectl cluster-info
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node <node-name>

kubectl get namespaces
kubectl get pods -A
kubectl get pods -n kube-system

kubectl config current-context
kubectl config get-contexts
kubectl config view

kind delete cluster --name devops-cluster
```

---

## 20. Final Takeaway

Day 50 was my first hands-on Kubernetes day.

I moved from simply running containers with Docker to understanding how Kubernetes manages containerized workloads through a control plane and worker nodes.

The most important concept I learned today is:

```text
Desired State
     ↓
Kubernetes Control Plane
     ↓
Worker Nodes
     ↓
Pods
     ↓
Containers
```

This is the foundation for the Kubernetes topics I will learn next, including Deployments, Services, ConfigMaps, Secrets, scaling, storage, networking, and eventually Kubernetes in cloud environments.

