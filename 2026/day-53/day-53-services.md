# Day 53 – Kubernetes Services

## Overview

Today I learned about **Kubernetes Services** and how they provide stable networking for Pods.

Pods are temporary resources. Their IP addresses can change whenever a Pod is recreated. A Kubernetes Service solves this problem by providing a stable network endpoint and automatically routing traffic to the Pods selected by the Service.

In this task, I created and tested:

* ClusterIP Service
* NodePort Service
* LoadBalancer Service
* Kubernetes DNS-based Service discovery
* Service Endpoints
* Pod-to-Service communication

---

## Objectives

* Understand why Kubernetes Services are required
* Create a Deployment with multiple Pods
* Expose the Deployment using ClusterIP
* Expose the Deployment using NodePort
* Understand LoadBalancer Services
* Test communication from inside the cluster
* Understand Kubernetes Service DNS
* Inspect Service Endpoints
* Compare the different Service types

---

# 1. Kubernetes Deployment

First, I created a Deployment containing three Nginx replicas.

### `app-deployment.yaml`

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: nginx
        image: nginx:1.25
        ports:
        - containerPort: 80
```

The Deployment creates three Pods.

```bash
kubectl apply -f app-deployment.yaml
kubectl get pods -o wide
```

The Pods receive individual IP addresses.

For example:

```text
Pod 1 → 10.244.0.5
Pod 2 → 10.244.0.6
Pod 3 → 10.244.0.7
```

These IP addresses should not be used as permanent application endpoints because Pods are replaceable.

---

# 2. Why Kubernetes Services?

Pods have temporary IP addresses.

If a Pod is deleted:

```text
Old Pod → 10.244.0.5
```

Kubernetes creates a replacement:

```text
New Pod → 10.244.0.10
```

Therefore, applications need a stable way to communicate with a group of Pods.

A Service provides:

* Stable IP address
* Stable DNS name
* Traffic routing
* Load balancing across selected Pods

The architecture is:

```text
Client
   |
   ↓
Service
   |
   +---- Pod 1
   |
   +---- Pod 2
   |
   +---- Pod 3
```

---

# 3. ClusterIP Service

ClusterIP is the default Kubernetes Service type.

It provides internal access to Pods from within the Kubernetes cluster.

### `clusterip-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-clusterip
spec:
  type: ClusterIP
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

The selector:

```yaml
selector:
  app: web-app
```

matches the Pod label:

```yaml
labels:
  app: web-app
```

This allows the Service to find the three Pods.

I applied the Service using:

```bash
kubectl apply -f clusterip-service.yaml
```

Then checked it:

```bash
kubectl get services
```

---

# 4. Testing ClusterIP

I created a temporary BusyBox Pod:

```bash
kubectl run test-client \
  --image=busybox:latest \
  --rm -it \
  --restart=Never \
  -- sh
```

Inside the Pod, I tested:

```bash
wget -qO- http://web-app-clusterip
```

The request returned the Nginx welcome page.

This verified that a Pod inside the cluster can communicate with the Deployment through the Service.

---

# 5. Kubernetes DNS

Kubernetes automatically creates DNS records for Services.

The general DNS format is:

```text
<service-name>.<namespace>.svc.cluster.local
```

For my Service:

```text
web-app-clusterip.default.svc.cluster.local
```

I tested the short DNS name:

```bash
wget -qO- http://web-app-clusterip
```

and the full DNS name:

```bash
wget -qO- http://web-app-clusterip.default.svc.cluster.local
```

Both resolved to the same Service.

I also tested DNS resolution using:

```bash
nslookup web-app-clusterip
```

The returned IP matched the ClusterIP shown by:

```bash
kubectl get services
```

---

# 6. Service Endpoints

Endpoints represent the Pods that currently receive traffic from a Service.

I checked the endpoints using:

```bash
kubectl get endpoints web-app-clusterip
```

I could also inspect the Service using:

```bash
kubectl describe service web-app-clusterip
```

The output showed the Pod IP addresses and port numbers.

For example:

```text
Endpoints:
10.244.0.5:80
10.244.0.6:80
10.244.0.7:80
```

This demonstrates that the Service is connected to the Pods selected by:

```yaml
selector:
  app: web-app
```

---

# 7. NodePort Service

NodePort exposes a Service through a port on every Kubernetes node.

### `nodeport-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-nodeport
spec:
  type: NodePort
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
```

I applied it using:

```bash
kubectl apply -f nodeport-service.yaml
```

Then checked:

```bash
kubectl get services
```

The NodePort was:

```text
30080
```

The traffic flow is:

```text
Client
   |
   ↓
NodeIP:30080
   |
   ↓
NodePort Service
   |
   ↓
Nginx Pods
```

For Docker Desktop, I tested:

```bash
curl http://localhost:30080
```

For Minikube, I used:

```bash
minikube service web-app-nodeport --url
```

---

# 8. LoadBalancer Service

LoadBalancer Services are designed for external access, particularly in cloud Kubernetes environments.

### `loadbalancer-service.yaml`

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-app-loadbalancer
spec:
  type: LoadBalancer
  selector:
    app: web-app
  ports:
  - port: 80
    targetPort: 80
```

I applied it using:

```bash
kubectl apply -f loadbalancer-service.yaml
```

Then checked:

```bash
kubectl get services
```

On a local Kubernetes cluster, the EXTERNAL-IP may show:

```text
<pending>
```

This is expected because a local cluster normally does not have a cloud provider automatically provisioning an external load balancer.

On a cloud Kubernetes environment, a LoadBalancer Service can provision or integrate with an external cloud load balancer.

---

# 9. Comparing Service Types

| Service Type | Access                               | Main Use                                  |
| ------------ | ------------------------------------ | ----------------------------------------- |
| ClusterIP    | Inside cluster                       | Internal service-to-service communication |
| NodePort     | Through node IP and port             | Development and testing                   |
| LoadBalancer | Through external/cloud load balancer | External production applications          |

---

# 10. Service Architecture

The three Service types can be visualized as:

```text
ClusterIP

Application
    |
    ↓
ClusterIP
    |
    +---- Pod
    +---- Pod
    +---- Pod
```

```text
NodePort

External Client
      |
      ↓
NodeIP:30080
      |
      ↓
NodePort
      |
      ↓
Pods
```

```text
LoadBalancer

Internet
   |
   ↓
Cloud Load Balancer
   |
   ↓
Kubernetes Service
   |
   ↓
Pods
```

A LoadBalancer Service can also have a ClusterIP and NodePort assigned.

I verified this using:

```bash
kubectl describe service web-app-loadbalancer
```

---

# 11. Important Kubernetes Service Concepts

### Selector

The Service selector determines which Pods receive traffic.

```yaml
selector:
  app: web-app
```

The selector must match the Pod labels.

---

### Port

The Service port is the port exposed by the Service.

```yaml
port: 80
```

---

### TargetPort

The targetPort is the port on the Pod/container.

```yaml
targetPort: 80
```

They do not have to be the same.

---

### NodePort

NodePort exposes the Service through a port on the Kubernetes nodes.

```yaml
nodePort: 30080
```

The standard NodePort range is:

```text
30000-32767
```

---

# 12. Pod Self-Healing Test

I also tested Kubernetes self-healing by deleting one of the Pods.

```bash
kubectl delete pod <pod-name>
```

Then:

```bash
kubectl get pods -o wide
```

The Deployment automatically created a replacement Pod.

The replacement received a different Pod IP.

However, the Service continued providing the same stable endpoint.

This demonstrates why applications should communicate through Services instead of directly using Pod IP addresses.

---

# 13. Cleanup

After completing the practical work, I removed all resources:

```bash
kubectl delete -f app-deployment.yaml
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml
```

I verified the cleanup:

```bash
kubectl get pods
kubectl get services
```

Only the default Kubernetes Service remained.

---

# 14. Commands Used

```bash
kubectl apply -f app-deployment.yaml

kubectl get deployments

kubectl get pods -o wide

kubectl apply -f clusterip-service.yaml

kubectl get services

kubectl get endpoints web-app-clusterip

kubectl describe service web-app-clusterip

kubectl run test-client --image=busybox:latest --rm -it --restart=Never -- sh

kubectl apply -f nodeport-service.yaml

kubectl get services -o wide

kubectl apply -f loadbalancer-service.yaml

kubectl describe service web-app-loadbalancer

kubectl delete -f app-deployment.yaml
kubectl delete -f clusterip-service.yaml
kubectl delete -f nodeport-service.yaml
kubectl delete -f loadbalancer-service.yaml
```

---

# 15. What I Learned

Through this practical, I learned that Kubernetes Services provide a stable networking layer for dynamic Pods.

The main concepts I learned were:

* Pods have temporary IP addresses
* Services provide stable networking
* ClusterIP provides internal access
* NodePort provides node-level external access
* LoadBalancer provides external access through cloud infrastructure
* Services use selectors to identify Pods
* Kubernetes automatically provides DNS for Services
* Endpoints show which Pods are receiving Service traffic
* Deployments and Services work together to provide scalable and reliable applications

---

# Conclusion

Kubernetes Services solve the networking problem created by dynamic Pods.

Instead of connecting directly to individual Pod IP addresses, applications communicate with a stable Service.

The basic architecture is:

```text
Deployment
    |
    +---- Pod
    +---- Pod
    +---- Pod
          ↑
          |
       Service
          |
          ↓
       Clients
```

This makes Kubernetes applications easier to scale, manage, and expose.

**Day 53 completed — Kubernetes Services.**

