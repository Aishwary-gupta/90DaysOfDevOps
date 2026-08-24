# Day 55 – Kubernetes Persistent Volumes & Persistent Volume Claims

Part of my **90 Days of DevOps** journey.

## Overview

Today I learned how Kubernetes manages persistent storage.

Pods and containers are ephemeral, which means data stored only inside temporary Pod storage can disappear when the Pod is deleted.

Kubernetes provides persistent storage using:

* PersistentVolumes (PV)
* PersistentVolumeClaims (PVC)
* StorageClasses
* Static provisioning
* Dynamic provisioning

---

## What I Practiced

### 1. Ephemeral Storage

Created a Pod using:

```yaml
emptyDir: {}
```

The Pod wrote a timestamped file to:

```text
/data/message.txt
```

After deleting and recreating the Pod, the original data was gone.

This demonstrated that `emptyDir` storage does not survive Pod deletion.

---

### 2. Static PersistentVolume

Created a manually provisioned PV with:

```text
Capacity: 1Gi
Access Mode: ReadWriteOnce
Reclaim Policy: Retain
Storage: hostPath
```

The PV initially appeared as:

```text
Available
```

---

### 3. PersistentVolumeClaim

Created a PVC requesting:

```text
500Mi
ReadWriteOnce
```

The PVC successfully bound to the manually created PV.

```text
PVC → PV
```

---

### 4. Persistent Data

Mounted the PVC into a Pod at:

```text
/data
```

After deleting and recreating the Pod, the data remained available.

This proved that persistent storage survives Pod deletion.

---

### 5. StorageClasses

Inspected the cluster's StorageClasses:

```bash
kubectl get storageclass
```

and:

```bash
kubectl describe storageclass
```

I examined:

* Provisioner
* Reclaim Policy
* Volume Binding Mode
* Default StorageClass

---

### 6. Dynamic Provisioning

Created a PVC using a StorageClass.

Kubernetes automatically created the PV.

The workflow became:

```text
PVC
 ↓
StorageClass
 ↓
Automatically created PV
 ↓
Pod
```

---

## Static vs Dynamic Provisioning

| Static                               | Dynamic                          |
| ------------------------------------ | -------------------------------- |
| PV created manually                  | PV created automatically         |
| More administrator work              | Less administrator work          |
| Storage is predefined                | Storage is provisioned on demand |
| Useful for controlled/manual storage | Useful for scalable workloads    |

---

## Access Modes

| Mode | Description                 |
| ---- | --------------------------- |
| RWO  | Read-write by a single node |
| ROX  | Read-only by many nodes     |
| RWX  | Read-write by many nodes    |

---

## Reclaim Policies

### Retain

The PV remains after its PVC is deleted.

```text
PVC deleted
     ↓
PV → Released
```

### Delete

The dynamically provisioned storage is deleted when the PVC is deleted, depending on the storage provisioner.

---

## PV Lifecycle

```text
Available
    ↓
Bound
    ↓
Released
```

---

## Files

```text
day-55/
├── ephemeral-pod.yaml
├── pv.yaml
├── pvc.yaml
├── persistent-pod.yaml
├── dynamic-pvc.yaml
├── dynamic-pod.yaml
├── day-55-persistent-volumes.md
└── README.md
```

---

## Useful Commands

```bash
kubectl get pv
kubectl get pvc
kubectl get storageclass
kubectl describe pv <pv-name>
kubectl describe pvc <pvc-name>
kubectl describe storageclass <storage-class>
```

---

## Key Takeaway

Pods are replaceable, but application data often needs to survive.

Kubernetes solves this using:

```text
Pod
 ↓
PVC
 ↓
PV
 ↓
Persistent Storage
```

Day 55 helped me understand how Kubernetes separates application workloads from persistent data.

---

## 90 Days of DevOps

**Day 55/90 – Kubernetes Persistent Volumes & PVCs**

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham #Kubernetes #DevOps #CloudComputing

