# Day 57 – Kubernetes Resource Requests, Limits & Probes

## Overview

Today I learned how Kubernetes manages **Pod resources** and monitors application health using **probes**.

Resource requests help Kubernetes decide where a Pod can be scheduled, while limits define the maximum CPU and memory the container can consume.

I also tested what happens when memory limits are exceeded and explored Kubernetes **liveness, readiness, and startup probes**.

---

## 1. Resource Requests & Limits

Example configuration:

```yaml
resources:
  requests:
    cpu: "100m"
    memory: "128Mi"
  limits:
    cpu: "250m"
    memory: "256Mi"
```

### Requests

Requests represent the minimum resources required by a container.

* Used by the Kubernetes scheduler
* Helps determine which node can run the Pod
* `100m` CPU = `0.1` CPU core
* `128Mi` = 128 MiB memory

### Limits

Limits define the maximum resources a container can use.

* CPU exceeding the limit is throttled
* Memory exceeding the limit can cause the container to be killed

Because the requests and limits are different, the Pod gets:

**QoS Class: `Burstable`**

---

## 2. OOMKilled

I created a Pod with a memory limit of `100Mi` and used the `stress` utility to allocate approximately `200M` of memory.

The container exceeded its memory limit and Kubernetes terminated it.

The important result was:

```text
Reason: OOMKilled
Exit Code: 137
```

Exit code `137` means the process was terminated with `SIGKILL`.

### Key Difference

* CPU → throttled when the limit is exceeded
* Memory → container can be terminated with `OOMKilled`

---

## 3. Pending Pod

I created a Pod requesting unrealistic resources:

```yaml
resources:
  requests:
    cpu: "100"
    memory: "128Gi"
```

The Pod remained in:

```text
Pending
```

The scheduler cannot place the Pod because no available node has enough requested resources.

`kubectl describe pod` shows a scheduling event similar to:

```text
Insufficient cpu
Insufficient memory
```

The exact message depends on the resources available in the cluster.

---

## 4. Liveness Probe

A **liveness probe** checks whether a container is still functioning.

Example:

```yaml
livenessProbe:
  exec:
    command:
      - cat
      - /tmp/healthy
  periodSeconds: 5
  failureThreshold: 3
```

In the test, the container initially created `/tmp/healthy` and later deleted it.

After three consecutive failed checks, Kubernetes restarted the container.

### Liveness

**Failure → Container restart**

---

## 5. Readiness Probe

A **readiness probe** determines whether a Pod is ready to receive traffic.

Example:

```yaml
readinessProbe:
  httpGet:
    path: /
    port: 80
  periodSeconds: 5
```

After removing the nginx `index.html`, the HTTP probe failed.

The Pod became:

```text
0/1 Ready
```

and was removed from the Service endpoints.

However, the container was **not restarted**.

### Readiness

**Failure → Removed from Service endpoints**

---

## 6. Startup Probe

A **startup probe** is useful for applications that require extra time to start.

Example:

```yaml
startupProbe:
  exec:
    command:
      - cat
      - /tmp/started
  periodSeconds: 5
  failureThreshold: 12
```

The container takes approximately 20 seconds to create `/tmp/started`.

The startup probe gives it up to:

```text
5 × 12 = 60 seconds
```

While the startup probe is running, Kubernetes does not run the liveness and readiness probes.

If `failureThreshold` were changed to `2`:

```text
5 × 2 = 10 seconds
```

the container would fail the startup probe before it finished starting and Kubernetes would restart/kill the container.

---

## 7. Probe Comparison

| Probe     | Purpose                   | Failure Result                 |
| --------- | ------------------------- | ------------------------------ |
| Liveness  | Is the container alive?   | Container restarted            |
| Readiness | Can it receive traffic?   | Removed from Service endpoints |
| Startup   | Has it finished starting? | Container killed/restarted     |

---

## 8. Important Commands

```bash
kubectl apply -f pod.yaml
kubectl get pods
kubectl get pods -w
kubectl describe pod <pod-name>
kubectl logs <pod-name>
kubectl get endpoints <service-name>
kubectl exec <pod-name> -- <command>
kubectl delete pod <pod-name>
kubectl delete svc <service-name>
```

---

## Key Learnings

* **Requests** are mainly used for scheduling.
* **Limits** control maximum resource consumption.
* CPU is compressible and can be throttled.
* Memory is incompressible and can result in `OOMKilled`.
* `137` is the typical exit code for an OOMKilled container.
* Liveness probes help Kubernetes restart unhealthy containers.
* Readiness probes control whether a Pod receives traffic.
* Startup probes protect slow-starting applications.
* QoS classes include `Guaranteed`, `Burstable`, and `BestEffort`.

## Conclusion

Day 57 helped me understand how Kubernetes combines **resource management with automated health monitoring**.

With resource requests and limits, Kubernetes can schedule workloads more intelligently and prevent containers from consuming unlimited resources. Probes add another layer of reliability by allowing Kubernetes to automatically detect unhealthy or unready applications.

