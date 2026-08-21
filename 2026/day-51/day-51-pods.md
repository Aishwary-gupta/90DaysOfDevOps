# Day 51 – Kubernetes Manifests and Pods

Today I started deploying workloads to Kubernetes by creating and managing Pods using YAML manifests.

## What I Learned

A Kubernetes manifest mainly contains:

* **apiVersion** – Defines the API version.
* **kind** – Defines the resource type, such as Pod.
* **metadata** – Contains the resource name and labels.
* **spec** – Defines the desired configuration of the resource.

## Practical Work

Created three Pod manifests:

* `nginx-pod.yaml` – Nginx web server
* `busybox-pod.yaml` – BusyBox container with a custom command
* `app-pod.yaml` – Nginx Pod with multiple labels

I also created a Redis Pod using:

```bash
kubectl run redis-pod --image=redis:latest
```

## Commands Practiced

```bash
kubectl apply -f nginx-pod.yaml
kubectl get pods
kubectl get pods -o wide
kubectl describe pod nginx-pod
kubectl logs nginx-pod
kubectl exec -it nginx-pod -- /bin/bash
kubectl get pods --show-labels
kubectl get pods -l app=nginx
kubectl apply -f nginx-pod.yaml --dry-run=client
kubectl apply -f nginx-pod.yaml --dry-run=server
```

## Imperative vs Declarative

**Imperative:** Directly tell Kubernetes what to do.

```bash
kubectl run redis-pod --image=redis:latest
```

**Declarative:** Define the desired state in YAML and apply it.

```bash
kubectl apply -f nginx-pod.yaml
```

Declarative configuration is more suitable for maintaining Kubernetes configurations because the YAML can be version-controlled and reused.

## Labels

Labels are key-value pairs used to organize and select Kubernetes resources.

Examples:

```text
app=nginx
environment=dev
team=backend
```

Filtering:

```bash
kubectl get pods -l app=nginx
kubectl get pods -l environment=dev
kubectl get pods -l team=backend
```

## Pod Debugging

I practiced:

```bash
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl exec -it <pod-name> -- /bin/sh
```

I also entered the Nginx container and tested the web server using:

```bash
curl localhost:80
```

## Important Learning

A standalone Pod is not automatically recreated after deletion because there is no controller managing it.

This is why Kubernetes applications are normally deployed using higher-level resources such as **Deployments**, which I will explore next.

## Screenshot

*Add screenshot of `kubectl get pods` showing the running Pods here.*

## Conclusion

Day 51 helped me understand Kubernetes YAML manifests, Pods, containers, labels, logs, shell access, validation, and the difference between imperative and declarative resource creation.

#90DaysOfDevOps

