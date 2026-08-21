# Day 52 – Kubernetes Namespaces and Deployments

## Overview

Today I learned how Kubernetes Namespaces and Deployments are used to organize and manage applications inside a Kubernetes cluster.

I created custom namespaces for development and staging, deployed Nginx Pods, created a multi-replica Deployment, tested Kubernetes self-healing, scaled the Deployment, performed a rolling update, and rolled back to the previous version.

## Topics Covered

* Kubernetes Namespaces
* Default and custom namespaces
* Pods across namespaces
* Kubernetes Deployments
* ReplicaSets
* Self-healing Pods
* Scaling Deployments
* Rolling updates
* Rollbacks
* Imperative and declarative configuration

## 1. Kubernetes Namespaces

Namespaces provide logical separation of Kubernetes resources inside a cluster.

I explored the default namespaces using:

```bash
kubectl get namespaces
```

I also inspected system Pods using:

```bash
kubectl get pods -n kube-system
```

## 2. Custom Namespaces

I created `dev` and `staging` namespaces:

```bash
kubectl create namespace dev
kubectl create namespace staging
```

I also created a `production` namespace using a YAML manifest.

Namespaces allow resources from different environments to be separated and managed independently.

## 3. Pods in Different Namespaces

I created Nginx Pods in the development and staging namespaces:

```bash
kubectl run nginx-dev --image=nginx:latest -n dev
kubectl run nginx-staging --image=nginx:latest -n staging
```

To see Pods in all namespaces:

```bash
kubectl get pods -A
```

Running `kubectl get pods` without `-n` only displays Pods from the current namespace.

## 4. Deployment

I created an Nginx Deployment with three replicas.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
  namespace: dev
  labels:
    app: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
        - name: nginx
          image: nginx:1.24
          ports:
            - containerPort: 80
```

The `replicas` field specifies how many Pods Kubernetes should maintain.

The `selector.matchLabels` connects the Deployment to its Pods, while `template` defines the Pod configuration.

## 5. Self-Healing

I deleted one of the Pods managed by the Deployment:

```bash
kubectl delete pod <pod-name> -n dev
```

Kubernetes automatically created a replacement Pod because the Deployment continuously maintains the desired number of replicas.

The replacement Pod received a different name.

This demonstrates Kubernetes self-healing.

## 6. Scaling

I scaled the Deployment from 3 replicas to 5:

```bash
kubectl scale deployment nginx-deployment --replicas=5 -n dev
```

I then scaled it down to 2:

```bash
kubectl scale deployment nginx-deployment --replicas=2 -n dev
```

When scaling down, Kubernetes terminated the extra Pods until only the desired number remained.

Scaling can also be performed declaratively by changing the `replicas` value in the YAML file and applying it again.

## 7. Rolling Update

I updated the Nginx image from version 1.24 to 1.25:

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.25 -n dev
```

I monitored the update using:

```bash
kubectl rollout status deployment/nginx-deployment -n dev
```

Kubernetes gradually replaced the old Pods with Pods using the new image.

## 8. Rollback

I checked the rollout history:

```bash
kubectl rollout history deployment/nginx-deployment -n dev
```

Then rolled back to the previous revision:

```bash
kubectl rollout undo deployment/nginx-deployment -n dev
```

After the rollback, the Deployment returned to the previous Nginx image version.

## 9. Useful Commands

```bash
kubectl get namespaces
kubectl get pods -A
kubectl get pods -n dev
kubectl get deployments -n dev
kubectl get replicasets -n dev
kubectl scale deployment nginx-deployment --replicas=5 -n dev
kubectl rollout status deployment/nginx-deployment -n dev
kubectl rollout history deployment/nginx-deployment -n dev
kubectl rollout undo deployment/nginx-deployment -n dev
```

## 10. Key Learnings

The main difference between a standalone Pod and a Deployment is that a Deployment continuously manages the desired state of the application.

A standalone Pod can disappear permanently when deleted, while a Pod managed by a Deployment is recreated automatically.

I also learned that Namespaces provide logical separation for resources and that Deployments provide replication, self-healing, scaling, rolling updates, and rollback capabilities.

## Screenshot

Add the screenshot showing:

```bash
kubectl get deployments -A
kubectl get pods -A
```

## Conclusion

Day 52 helped me move from manually running individual Kubernetes Pods to managing applications using Deployments and Namespaces.

I now understand how Kubernetes maintains the desired number of replicas, automatically replaces failed Pods, scales applications, and performs rolling updates and rollbacks.

