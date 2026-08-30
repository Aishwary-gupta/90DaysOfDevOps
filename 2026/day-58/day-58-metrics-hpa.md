# Day 58 – Metrics Server and Horizontal Pod Autoscaler (HPA)

## 📌 Overview

Today I learned how Kubernetes can automatically scale applications based on actual resource usage.

The focus was on:

* Installing Metrics Server
* Using `kubectl top`
* Understanding actual CPU and memory usage
* Creating a Deployment with CPU requests
* Creating a Horizontal Pod Autoscaler
* Generating CPU load
* Watching Kubernetes automatically scale Pods
* Creating an HPA declaratively using `autoscaling/v2`
* Understanding HPA scaling behavior

---

## 🏗️ Architecture

```text
                  Metrics Server
                       │
                       │ CPU / Memory Metrics
                       ▼
                Horizontal Pod
                 Autoscaler
                       │
             Scale Up / Scale Down
                       │
                       ▼
                  Deployment
                  php-apache
                       │
             ┌─────────┼─────────┐
             ▼         ▼         ▼
           Pod       Pod       Pod
             ▲
             │
        HTTP Requests
             │
       Load Generator
```

---

# Task 1 – Install Metrics Server

First, I checked whether Metrics Server was already running:

```bash
kubectl get pods -n kube-system | grep metrics-server
```

For Minikube, Metrics Server can be enabled using:

```bash
minikube addons enable metrics-server
```

After waiting for the metrics to become available, I verified the installation:

```bash
kubectl top nodes
```

and:

```bash
kubectl top pods -A
```

### Node Metrics

```text
Paste your actual `kubectl top nodes` output here.
```

### Screenshot

---

# Task 2 – Explore `kubectl top`

I used:

```bash
kubectl top nodes
```

```bash
kubectl top pods -A
```

```bash
kubectl top pods -A --sort-by=cpu
```

`kubectl top` displays the current resource usage of nodes and Pods.

It is important to understand that actual usage is different from Kubernetes resource requests and limits.

### Difference

```text
Requests → Used by Kubernetes for scheduling

Limits   → Maximum resources a container can consume

kubectl top → Actual current resource usage
```

### Highest CPU Pod

```text
Pod: <ENTER YOUR POD NAME>
CPU: <ENTER CPU VALUE>
```

### Screenshot

---

# Task 3 – Create Deployment with CPU Requests

I created a Deployment using the Kubernetes HPA example image:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: php-apache
spec:
  replicas: 1
  selector:
    matchLabels:
      run: php-apache
  template:
    metadata:
      labels:
        run: php-apache
    spec:
      containers:
        - name: php-apache
          image: registry.k8s.io/hpa-example
          ports:
            - containerPort: 80
          resources:
            requests:
              cpu: 200m
```

Applied with:

```bash
kubectl apply -f php-apache.yaml
```

I then exposed the Deployment:

```bash
kubectl expose deployment php-apache --port=80
```

The CPU request is important because HPA uses CPU utilization relative to the requested CPU.

---

# Task 4 – Create HPA

I created an HPA using:

```bash
kubectl autoscale deployment php-apache \
  --cpu-percent=50 \
  --min=1 \
  --max=10
```

I verified it using:

```bash
kubectl get hpa
```

and:

```bash
kubectl describe hpa php-apache
```

### HPA Output

```text
Paste your actual `kubectl get hpa` output here.
```

### TARGETS

The TARGETS column shows current CPU utilization compared with the configured target.

Example:

```text
2% / 50%
```

This means the Pods are currently using approximately 2% of their requested CPU, while the HPA target is 50%.

---

# Task 5 – Generate Load

I created a load generator:

```bash
kubectl run load-generator \
  --image=busybox:1.36 \
  --restart=Never \
  -- /bin/sh -c \
  "while true; do wget -q -O- http://php-apache; done"
```

I monitored the HPA:

```bash
kubectl get hpa php-apache --watch
```

I also monitored Pods:

```bash
kubectl get pods --watch
```

and CPU usage:

```bash
kubectl top pods
```

As CPU usage increased above the configured 50% target, HPA increased the number of replicas.

### Scaling Observation

```text
Initial replicas: 1
Maximum replicas: 10
Replicas reached under load: <ENTER YOUR VALUE>
```

### Screenshot

---

# Task 6 – HPA Using YAML

I deleted the imperative HPA:

```bash
kubectl delete hpa php-apache
```

Then I created an HPA using `autoscaling/v2`.

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: php-apache
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: php-apache

  minReplicas: 1
  maxReplicas: 10

  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50

  behavior:
    scaleUp:
      stabilizationWindowSeconds: 0
      policies:
        - type: Percent
          value: 100
          periodSeconds: 15

    scaleDown:
      stabilizationWindowSeconds: 300
      policies:
        - type: Percent
          value: 50
          periodSeconds: 60
```

Applied with:

```bash
kubectl apply -f hpa.yaml
```

Verified with:

```bash
kubectl get hpa
```

and:

```bash
kubectl describe hpa php-apache
```

---

# Understanding HPA Behavior

The `behavior` section controls how quickly the HPA scales the application.

## Scale Up

```yaml
scaleUp:
  stabilizationWindowSeconds: 0
```

The HPA can react immediately to increased demand.

## Scale Down

```yaml
scaleDown:
  stabilizationWindowSeconds: 300
```

Kubernetes waits for a stabilization period before reducing replicas.

This helps prevent rapid scaling up and down when traffic fluctuates.

---

# HPA Replica Calculation

A simplified formula for CPU-based scaling is:

```text
desiredReplicas =
ceil(currentReplicas × currentUsage / targetUsage)
```

For example:

```text
Current replicas = 2
Current CPU      = 80%
Target CPU       = 50%
```

Then:

```text
ceil(2 × 80 / 50)
= ceil(3.2)
= 4
```

Therefore, HPA would target approximately:

```text
4 replicas
```

---

# `autoscaling/v1` vs `autoscaling/v2`

| Feature          | autoscaling/v1 | autoscaling/v2 |
| ---------------- | -------------- | -------------- |
| CPU scaling      | ✅              | ✅              |
| Memory scaling   | ❌              | ✅              |
| Multiple metrics | ❌              | ✅              |
| Custom metrics   | Limited        | ✅              |
| Scaling behavior | Basic          | Advanced       |
| Stabilization    | Limited        | ✅              |
| Scaling policies | Basic          | ✅              |

For modern Kubernetes applications, `autoscaling/v2` provides much more flexibility.

---

# Important Lessons

### 1. Metrics Server provides resource metrics

Without Metrics Server, commands such as:

```bash
kubectl top pods
```

cannot provide the required resource usage information.

### 2. HPA needs resource requests

For CPU utilization-based HPA, CPU requests are essential.

Example:

```yaml
resources:
  requests:
    cpu: 200m
```

Without an appropriate CPU request, HPA cannot calculate CPU utilization correctly.

### 3. `kubectl top` shows actual usage

It does not show the configured requests or limits.

### 4. HPA is reactive

It continuously evaluates resource metrics and adjusts the number of replicas according to demand.

### 5. Scale-up and scale-down can behave differently

Fast scale-up helps handle sudden traffic increases, while slower scale-down prevents unnecessary fluctuations.

---

# Verification Checklist

* [x] Metrics Server installed
* [x] `kubectl top nodes` working
* [x] `kubectl top pods -A` working
* [x] Deployment created
* [x] CPU request configured
* [x] Service exposed
* [x] HPA created
* [x] Load generated
* [x] Pod replicas increased
* [x] HPA created using `autoscaling/v2`
* [x] Scaling behavior configured
* [x] Screenshots captured
* [x] Resources cleaned up

---

# Cleanup

After completing the experiment:

```bash
kubectl delete hpa php-apache
kubectl delete service php-apache
kubectl delete deployment php-apache
kubectl delete pod load-generator --ignore-not-found
```

Metrics Server was intentionally left installed.

---

# Key Takeaway

Day 58 showed how Kubernetes can automatically respond to changing application demand.

The complete workflow was:

```text
Application
    ↓
Resource Requests
    ↓
Metrics Server
    ↓
HPA
    ↓
Monitor CPU
    ↓
Increase / Decrease Replicas
    ↓
Handle Variable Traffic
```

This is one of the key mechanisms Kubernetes provides for building applications that can automatically adapt to changing workloads.

