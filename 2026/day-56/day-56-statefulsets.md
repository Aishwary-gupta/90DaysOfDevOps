# Day 56 – Kubernetes StatefulSets

## Overview

Today I learned about Kubernetes StatefulSets and how they differ from Deployments.

Deployments are designed primarily for stateless applications where individual Pods are interchangeable. StatefulSets are designed for stateful workloads that require stable network identities, predictable Pod names, ordered deployment, and persistent storage.

Common StatefulSet use cases include:

* MySQL
* PostgreSQL
* MongoDB
* Kafka
* ZooKeeper
* Redis clusters

---

## Deployment vs StatefulSet

| Feature          | Deployment                           | StatefulSet                              |
| ---------------- | ------------------------------------ | ---------------------------------------- |
| Pod names        | Random/generated                     | Stable and ordered                       |
| Example names    | `app-abc123`                         | `web-0`, `web-1`, `web-2`                |
| Startup          | Generally parallel                   | Ordered                                  |
| Network identity | Not stable                           | Stable DNS identity                      |
| Storage          | Usually shared/configured separately | Per-Pod PVCs with `volumeClaimTemplates` |
| Pod replacement  | New random identity                  | Same ordinal identity                    |
| Scaling down     | Pods removed                         | Highest ordinal Pods removed first       |

---

## Task 1 – Deployment Behavior

I created an nginx Deployment with three replicas:

```bash
kubectl create deployment nginx-deployment --image=nginx --replicas=3
```

The Pods received generated names such as:

```text
nginx-deployment-xxxxxxxxxx-xxxxx
```

After deleting one Pod, Kubernetes created a replacement with a different generated name.

This demonstrates why Deployments are not ideal for applications where each instance needs a stable identity.

For database clusters, stable identity is important because a database instance may need to be associated with specific persistent storage and a predictable hostname.

---

## Task 2 – Headless Service

I created a Headless Service using:

```yaml
clusterIP: None
```

The Service was named:

```text
web-headless
```

The important configuration was:

```yaml
spec:
  clusterIP: None
```

Checking the Service showed:

```text
CLUSTER-IP: None
```

A Headless Service does not provide a single virtual ClusterIP for load balancing. Instead, it allows DNS to return the individual addresses of the selected Pods.

---

## Task 3 – StatefulSet

The StatefulSet was configured with three replicas and nginx:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: web
spec:
  serviceName: web-headless
  replicas: 3

  selector:
    matchLabels:
      app: web

  template:
    metadata:
      labels:
        app: web

    spec:
      containers:
        - name: nginx
          image: nginx:latest
          ports:
            - containerPort: 80

          volumeMounts:
            - name: web-data
              mountPath: /usr/share/nginx/html

  volumeClaimTemplates:
    - metadata:
        name: web-data
      spec:
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: 100Mi
```

The Pods received stable names:

```text
web-0
web-1
web-2
```

They were created in ordinal order:

```text
web-0 → web-1 → web-2
```

The PVCs were:

```text
web-data-web-0
web-data-web-1
web-data-web-2
```

Each StatefulSet Pod received its own PVC.

---

## Task 4 – Stable Network Identity

The DNS format for a StatefulSet Pod is:

```text
<pod-name>.<service-name>.<namespace>.svc.cluster.local
```

For example:

```text
web-0.web-headless.default.svc.cluster.local
```

I used a temporary BusyBox Pod to perform DNS lookups:

```bash
nslookup web-0.web-headless.default.svc.cluster.local
nslookup web-1.web-headless.default.svc.cluster.local
nslookup web-2.web-headless.default.svc.cluster.local
```

The returned IP addresses matched the corresponding Pod IPs shown by:

```bash
kubectl get pods -o wide
```

This demonstrates that each StatefulSet Pod has a predictable DNS identity.

---

## Task 5 – Persistent Storage

I wrote unique data into `web-0`:

```bash
kubectl exec web-0 -- sh -c \
"echo 'Data from web-0' > /usr/share/nginx/html/index.html"
```

The data was verified with:

```bash
kubectl exec web-0 -- cat /usr/share/nginx/html/index.html
```

The output was:

```text
Data from web-0
```

I then deleted the Pod:

```bash
kubectl delete pod web-0
```

Kubernetes recreated the Pod with the same stable name:

```text
web-0
```

After recreation, the data was still present:

```text
Data from web-0
```

This happened because the recreated Pod reattached to its existing PVC:

```text
web-data-web-0
```

Therefore, deleting the Pod did not delete the persistent data.

---

## Task 6 – Ordered Scaling

I scaled the StatefulSet from three to five replicas:

```bash
kubectl scale statefulset web --replicas=5
```

The new Pods were created in order:

```text
web-3
web-4
```

The PVCs became:

```text
web-data-web-0
web-data-web-1
web-data-web-2
web-data-web-3
web-data-web-4
```

I then scaled the StatefulSet back to three replicas:

```bash
kubectl scale statefulset web --replicas=3
```

The highest ordinal Pods were removed first:

```text
web-4
web-3
```

The PVCs remained after scaling down.

Therefore, after scaling down from five to three replicas, **five PVCs still existed**.

---

## Task 7 – Cleanup

I deleted the StatefulSet:

```bash
kubectl delete statefulset web
```

I also deleted the Headless Service:

```bash
kubectl delete service web-headless
```

The PVCs were not automatically deleted.

I manually removed them using:

```bash
kubectl delete pvc web-data-web-0 \
web-data-web-1 \
web-data-web-2 \
web-data-web-3 \
web-data-web-4
```

This demonstrates that StatefulSet storage requires explicit cleanup.

---

## Key Concepts Learned

### StatefulSet

A StatefulSet provides:

* Stable Pod names
* Stable network identities
* Ordered creation
* Ordered termination
* Stable storage association
* Individual PVCs for replicas

### Headless Service

A Headless Service uses:

```yaml
clusterIP: None
```

It provides DNS-based discovery of individual Pods rather than exposing a single virtual ClusterIP.

### volumeClaimTemplates

`volumeClaimTemplates` automatically creates a separate PVC for each StatefulSet replica.

For example:

```text
web-0 → web-data-web-0
web-1 → web-data-web-1
web-2 → web-data-web-2
```

### Stable DNS

Each StatefulSet Pod receives a predictable DNS name:

```text
web-0.web-headless.default.svc.cluster.local
web-1.web-headless.default.svc.cluster.local
web-2.web-headless.default.svc.cluster.local
```

---

## Screenshots

The following screenshots were captured during the practical:

1. Deployment Pods showing generated names
2. StatefulSet Pods showing `web-0`, `web-1`, and `web-2`
3. PVCs showing individual storage claims
4. Headless Service showing `CLUSTER-IP: None`
5. DNS lookup for `web-0`
6. DNS lookup for `web-1`
7. DNS lookup for `web-2`
8. Persistent data before Pod deletion
9. Persistent data after `web-0` recreation
10. PVCs remaining after StatefulSet scale-down

---

## Conclusion

Today I learned why StatefulSets are important for stateful Kubernetes applications.

Unlike Deployments, StatefulSets provide stable Pod identities, predictable DNS names, ordered startup and shutdown, and dedicated persistent storage for each replica.

The most important flow I learned was:

```text
StatefulSet
    ↓
Stable Pod Identity
    ↓
Headless Service
    ↓
Stable DNS
    ↓
volumeClaimTemplates
    ↓
Per-Pod Persistent Storage
```

This makes StatefulSets much more suitable for database clusters and other applications where Pod identity and persistent data matter.

