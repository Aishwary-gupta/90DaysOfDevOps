# Day 60 – Kubernetes Capstone: WordPress + MySQL

![Kubernetes](https://img.shields.io/badge/Kubernetes-Capstone-326CE5?style=for-the-badge\&logo=kubernetes\&logoColor=white)
![WordPress](https://img.shields.io/badge/WordPress-Application-21759B?style=for-the-badge\&logo=wordpress\&logoColor=white)
![MySQL](https://img.shields.io/badge/MySQL-Database-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white)
![Helm](https://img.shields.io/badge/Helm-Package%20Manager-0F1689?style=for-the-badge\&logo=helm\&logoColor=white)

## 📌 Overview

Day 60 is the Kubernetes capstone of my 90 Days of DevOps journey.

Over the previous Kubernetes days, I learned individual concepts such as:

* Namespaces
* Pods
* Deployments
* Services
* ConfigMaps
* Secrets
* Persistent Volumes and PVCs
* StatefulSets
* Resource Requests and Limits
* Liveness and Readiness Probes
* Metrics Server
* Horizontal Pod Autoscaler
* Helm

Today, I combined these concepts into one complete application stack:

**WordPress + MySQL running on Kubernetes.**

The goal was not just to deploy the application, but also to verify:

* Application availability
* Database connectivity
* Persistent storage
* Self-healing
* Health checks
* Resource management
* Horizontal autoscaling

---

# 🏗️ Architecture

```text
                         Kubernetes Cluster
                                │
                                ▼
                        ┌───────────────┐
                        │   capstone    │
                        │   Namespace   │
                        └───────┬───────┘
                                │
              ┌─────────────────┴─────────────────┐
              │                                   │
              ▼                                   ▼
      ┌───────────────┐                   ┌───────────────┐
      │   WordPress   │                   │     MySQL     │
      │   Deployment  │                   │  StatefulSet  │
      │   2 Replicas  │                   │    mysql-0    │
      └───────┬───────┘                   └───────┬───────┘
              │                                   │
              │                                   │
              ▼                                   ▼
      ┌───────────────┐                   ┌───────────────┐
      │    NodePort   │                   │ Headless      │
      │    Service    │                   │ Service       │
      │    :30080     │                   │ clusterIP:none│
      └───────┬───────┘                   └───────┬───────┘
              │                                   │
              ▼                                   ▼
        Browser/User                       mysql-0.mysql
                                                  │
                                                  ▼
                                          ┌───────────────┐
                                          │      PVC      │
                                          │      1Gi      │
                                          └───────────────┘

Secrets
   │
   ├── MySQL root password
   ├── MySQL database
   ├── MySQL user
   └── MySQL password
          │
          ├──────────────► MySQL
          │
          └──────────────► WordPress

ConfigMap
   │
   ├── WORDPRESS_DB_HOST
   └── WORDPRESS_DB_NAME
          │
          └──────────────► WordPress

HPA
   │
   └── WordPress Deployment
       Min: 2
       Max: 10
       CPU Target: 50%
```

---

# 🚀 Step 1 – Create the Namespace

Create the namespace:

```bash
kubectl create namespace capstone
```

Verify:

```bash
kubectl get namespaces
```

Set `capstone` as the current namespace:

```bash
kubectl config set-context --current --namespace=capstone
```

Verify:

```bash
kubectl config view --minify --output 'jsonpath={..namespace}'
```

Expected:

```text
capstone
```

### Why?

A namespace logically isolates our capstone application from other Kubernetes workloads.

---

# 🔐 Step 2 – Create MySQL Secret

Create `mysql-secret.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: mysql-secret
type: Opaque
stringData:
  MYSQL_ROOT_PASSWORD: rootpassword
  MYSQL_DATABASE: wordpress
  MYSQL_USER: wordpress
  MYSQL_PASSWORD: wordpresspassword
```

Apply:

```bash
kubectl apply -f mysql-secret.yaml
```

Verify:

```bash
kubectl get secret
```

### Why use a Secret?

Passwords should not be directly embedded inside application manifests.

The Secret stores:

| Key                   | Purpose                     |
| --------------------- | --------------------------- |
| `MYSQL_ROOT_PASSWORD` | MySQL root password         |
| `MYSQL_DATABASE`      | Database WordPress will use |
| `MYSQL_USER`          | WordPress database user     |
| `MYSQL_PASSWORD`      | Database user password      |

> For a real production environment, use stronger credentials and a proper secret-management system rather than committing passwords to Git.

---

# 🗄️ Step 3 – Create MySQL Headless Service

Create `mysql-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mysql
spec:
  clusterIP: None
  selector:
    app: mysql
  ports:
    - port: 3306
      targetPort: 3306
```

Apply:

```bash
kubectl apply -f mysql-service.yaml
```

Verify:

```bash
kubectl get svc
```

Expected:

```text
mysql    ClusterIP   None
```

### Why Headless Service?

A normal Service provides a virtual IP.

A Headless Service uses:

```yaml
clusterIP: None
```

This allows Kubernetes DNS to directly resolve individual StatefulSet Pods.

For our MySQL Pod:

```text
mysql-0.mysql.capstone.svc.cluster.local
```

---

# 🐬 Step 4 – Deploy MySQL StatefulSet

Create `mysql-statefulset.yaml`:

```yaml
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mysql
spec:
  serviceName: mysql
  replicas: 1

  selector:
    matchLabels:
      app: mysql

  template:
    metadata:
      labels:
        app: mysql

    spec:
      containers:
        - name: mysql
          image: mysql:8.0

          ports:
            - containerPort: 3306

          envFrom:
            - secretRef:
                name: mysql-secret

          resources:
            requests:
              cpu: 250m
              memory: 512Mi
            limits:
              cpu: 500m
              memory: 1Gi

          volumeMounts:
            - name: mysql-storage
              mountPath: /var/lib/mysql

  volumeClaimTemplates:
    - metadata:
        name: mysql-storage
      spec:
        accessModes:
          - ReadWriteOnce

        resources:
          requests:
            storage: 1Gi
```

Apply:

```bash
kubectl apply -f mysql-statefulset.yaml
```

Check:

```bash
kubectl get statefulset
```

Then:

```bash
kubectl get pods
```

Expected:

```text
mysql-0    1/1    Running
```

---

# 💾 Understanding MySQL Persistence

The StatefulSet creates a PVC automatically through:

```yaml
volumeClaimTemplates:
```

Check:

```bash
kubectl get pvc
```

Expected:

```text
mysql-storage-mysql-0    Bound    1Gi
```

The database stores its files inside:

```text
/var/lib/mysql
```

which is backed by persistent storage.

Therefore, deleting the MySQL Pod does **not** automatically delete the database data.

---

# 🔎 Step 5 – Verify MySQL

Execute MySQL inside the Pod:

```bash
kubectl exec -it mysql-0 -- mysql -u wordpress -pwordpresspassword -e "SHOW DATABASES;"
```

Expected output should contain:

```text
Database
information_schema
wordpress
```

The important result is:

```text
wordpress
```

This confirms that the MySQL database required by WordPress exists.

---

# ⚙️ Step 6 – Create WordPress ConfigMap

Create `wordpress-configmap.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: wordpress-config
data:
  WORDPRESS_DB_HOST: mysql-0.mysql.capstone.svc.cluster.local:3306
  WORDPRESS_DB_NAME: wordpress
```

Apply:

```bash
kubectl apply -f wordpress-configmap.yaml
```

Verify:

```bash
kubectl get configmap
```

### Why ConfigMap?

ConfigMaps store non-sensitive configuration.

Here:

```text
WORDPRESS_DB_HOST
WORDPRESS_DB_NAME
```

are configuration values.

Passwords remain inside the Secret.

---

# 🌐 Step 7 – Deploy WordPress

Create `wordpress-deployment.yaml`:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: wordpress
spec:
  replicas: 2

  selector:
    matchLabels:
      app: wordpress

  template:
    metadata:
      labels:
        app: wordpress

    spec:
      containers:
        - name: wordpress
          image: wordpress:latest

          ports:
            - containerPort: 80

          envFrom:
            - configMapRef:
                name: wordpress-config

          env:
            - name: WORDPRESS_DB_USER
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: MYSQL_USER

            - name: WORDPRESS_DB_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: mysql-secret
                  key: MYSQL_PASSWORD

          resources:
            requests:
              cpu: 100m
              memory: 128Mi

            limits:
              cpu: 500m
              memory: 512Mi

          livenessProbe:
            httpGet:
              path: /wp-login.php
              port: 80
            initialDelaySeconds: 60
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5

          readinessProbe:
            httpGet:
              path: /wp-login.php
              port: 80
            initialDelaySeconds: 30
            periodSeconds: 10
            timeoutSeconds: 5
            failureThreshold: 5
```

Apply:

```bash
kubectl apply -f wordpress-deployment.yaml
```

Check:

```bash
kubectl get deployment
```

Check Pods:

```bash
kubectl get pods
```

Expected:

```text
wordpress-xxxxx    1/1    Running
wordpress-yyyyy    1/1    Running
```

---

# ❤️ Understanding the Probes

## Liveness Probe

The liveness probe checks whether the container is alive.

```yaml
livenessProbe:
  httpGet:
    path: /wp-login.php
    port: 80
```

If the application becomes unhealthy, Kubernetes can restart the container.

---

## Readiness Probe

The readiness probe determines whether the Pod is ready to receive traffic.

If WordPress is not ready, Kubernetes does not send Service traffic to that Pod.

This prevents users from being sent to an application that is still starting.

---

# 🌍 Step 8 – Create WordPress NodePort Service

Create `wordpress-service.yaml`:

```yaml
apiVersion: v1
kind: Service
metadata:
  name: wordpress
spec:
  type: NodePort

  selector:
    app: wordpress

  ports:
    - port: 80
      targetPort: 80
      nodePort: 30080
```

Apply:

```bash
kubectl apply -f wordpress-service.yaml
```

Verify:

```bash
kubectl get svc
```

Expected:

```text
wordpress    NodePort    ...    80:30080/TCP
```

---

# 🖥️ Step 9 – Access WordPress

## Minikube

```bash
minikube service wordpress -n capstone
```

This opens the WordPress application.

## Kind

Use port forwarding:

```bash
kubectl port-forward svc/wordpress 8080:80 -n capstone
```

Then open:

```text
http://localhost:8080
```

You should see the WordPress setup screen.

Complete the setup wizard and create a test blog post.

For example:

```text
Title: My Kubernetes Capstone
Content: WordPress is running on Kubernetes!
```

---

# 🔄 Step 10 – Test Self-Healing

First check the Pods:

```bash
kubectl get pods
```

Delete one WordPress Pod:

```bash
kubectl delete pod <wordpress-pod-name>
```

Immediately watch:

```bash
kubectl get pods -w
```

The Deployment should create a replacement Pod.

Check:

```bash
kubectl get pods
```

The desired state should return to:

```text
2 WordPress Pods
```

### Result

The Deployment automatically recreated the deleted Pod.

This demonstrates Kubernetes self-healing.

---

# 💾 Step 11 – Test MySQL Persistence

Delete the MySQL Pod:

```bash
kubectl delete pod mysql-0
```

Watch:

```bash
kubectl get pods -w
```

The StatefulSet recreates:

```text
mysql-0
```

Check the PVC:

```bash
kubectl get pvc
```

The PVC should remain bound.

After MySQL becomes ready, verify the database again:

```bash
kubectl exec -it mysql-0 -- mysql -u wordpress -pwordpresspassword -e "SHOW DATABASES;"
```

Then refresh WordPress.

### Expected Result

The WordPress installation and blog post should still exist.

This demonstrates that:

**Pod deletion ≠ data deletion**

because the database is backed by persistent storage.

---

# 📈 Step 12 – Configure Horizontal Pod Autoscaler

Create `wordpress-hpa.yaml`:

```yaml
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: wordpress-hpa
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: wordpress

  minReplicas: 2
  maxReplicas: 10

  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 50
```

Apply:

```bash
kubectl apply -f wordpress-hpa.yaml
```

Check:

```bash
kubectl get hpa
```

Expected configuration:

```text
MINPODS   MAXPODS   TARGET
2         10        50%
```

Check the full application:

```bash
kubectl get all
```

---

# 📊 Step 13 – Verify Metrics

HPA requires resource metrics.

Check:

```bash
kubectl top pods
```

If metrics are available, you should see CPU and memory usage.

For example:

```text
NAME                    CPU(cores)   MEMORY(bytes)
wordpress-xxxxx         20m          150Mi
wordpress-yyyyy         18m          145Mi
mysql-0                 80m          400Mi
```

---

# ⚓ Step 14 – Bonus: Compare With Helm

Create a separate namespace:

```bash
kubectl create namespace helm-wordpress
```

Add Bitnami repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Update:

```bash
helm repo update
```

Install:

```bash
helm install wp-helm bitnami/wordpress -n helm-wordpress
```

Check:

```bash
kubectl get all -n helm-wordpress
```

Inspect Helm:

```bash
helm list -n helm-wordpress
```

### Important

The Bitnami WordPress chart uses MariaDB by default rather than MySQL, so this is not an identical database stack.

Helm provides a much faster and more configurable way to deploy a complete application, while manually writing manifests gives more direct control over individual Kubernetes resources.

Clean up:

```bash
helm uninstall wp-helm -n helm-wordpress
kubectl delete namespace helm-wordpress
```

---

# 🔍 Step 15 – Final Verification

Run:

```bash
kubectl get all
```

Also check:

```bash
kubectl get pvc
kubectl get secrets
kubectl get configmaps
kubectl get hpa
```

A useful final command is:

```bash
kubectl get all,pvc,configmap,secret,hpa
```

---

# 🧹 Step 16 – Cleanup

Delete the entire capstone namespace:

```bash
kubectl delete namespace capstone
```

Verify:

```bash
kubectl get namespace capstone
```

It should no longer exist.

Reset your default namespace:

```bash
kubectl config set-context --current --namespace=default
```

Verify:

```bash
kubectl config view --minify --output 'jsonpath={..namespace}'
```

Expected:

```text
default
```

---

# 🧩 Kubernetes Concepts Used

| Concept                  | Day Learned | How It Was Used                    |
| ------------------------ | ----------: | ---------------------------------- |
| Namespace                |      Day 52 | Isolated the capstone application  |
| Deployment               |      Day 52 | Managed WordPress replicas         |
| Service                  |      Day 53 | Exposed WordPress and MySQL        |
| NodePort                 |      Day 53 | Exposed WordPress externally       |
| ConfigMap                |      Day 54 | Stored WordPress configuration     |
| Secret                   |      Day 54 | Stored database credentials        |
| Persistent Volume / PVC  |      Day 55 | Persisted MySQL data               |
| StatefulSet              |      Day 56 | Managed MySQL with stable identity |
| Headless Service         |      Day 56 | Provided stable MySQL DNS          |
| Resource Requests/Limits |      Day 57 | Controlled CPU and memory          |
| Liveness Probe           |      Day 57 | Checked WordPress health           |
| Readiness Probe          |      Day 57 | Controlled traffic to ready Pods   |
| HPA                      |      Day 58 | Automatically scaled WordPress     |
| Helm                     |      Day 59 | Compared packaged deployment       |

---

# 🧪 Results

## WordPress Deployment

```text
NAME                        READY   STATUS
wordpress-xxxxxxxxxx        1/1     Running
wordpress-yyyyyyyyyy        1/1     Running
```

## MySQL

```text
NAME      READY   STATUS
mysql-0   1/1     Running
```

## Persistent Storage

```text
NAME                    STATUS   CAPACITY
mysql-storage-mysql-0   Bound    1Gi
```

## HPA

```text
NAME            MINPODS   MAXPODS   TARGET
wordpress-hpa   2         10        50%
```

## Self-Healing Test

A WordPress Pod was manually deleted.

**Result:** Deployment automatically created a replacement Pod.

## Persistence Test

The MySQL Pod was manually deleted.

**Result:** StatefulSet recreated `mysql-0`, the PVC remained attached, and the WordPress data remained available.

---

# 🧠 Reflection

## What was hardest?

The most challenging part was connecting multiple Kubernetes concepts together rather than working with individual resources.

Understanding the DNS relationship between the StatefulSet and its Headless Service was especially important:

```text
mysql-0.mysql.capstone.svc.cluster.local
```

---

## What clicked?

The biggest realization was understanding that Kubernetes resources work together.

A Deployment manages application replicas.

A Service provides networking.

A ConfigMap provides configuration.

A Secret provides sensitive values.

A StatefulSet manages stateful workloads.

A PVC provides persistent storage.

Probes provide health information.

HPA provides automatic scaling.

Each concept solves a different problem, but together they form a complete platform.

---

## What would I add for production?

For a production deployment, I would add:

* Ingress with TLS
* Proper DNS
* Strong secrets management
* External database or managed MySQL
* Automated backups
* Monitoring with Prometheus and Grafana
* Centralized logging
* NetworkPolicies
* PodDisruptionBudgets
* SecurityContext
* Non-root containers where supported
* Resource tuning based on real workload data
* GitOps using Argo CD
* CI/CD deployment automation
* Disaster recovery strategy
* Multiple availability zones

---

# 🎯 Final Takeaway

This capstone brought together the major Kubernetes concepts I learned throughout the previous ten days.

Instead of deploying isolated Pods and Services, I deployed a complete application consisting of:

**WordPress + MySQL + Persistent Storage + Health Checks + Resource Management + Autoscaling**

The biggest lesson was that Kubernetes is not just about running containers.

It is about managing applications reliably at scale.

---

## 📸 Evidence

Add screenshots below:

### WordPress Running

![WordPress Running](screenshots/wordpress-running.png)

### Kubernetes Resources

![kubectl get all](screenshots/kubectl-get-all.png)

### HPA

![HPA](screenshots/hpa.png)

### MySQL Persistence Test

![Persistence Test](screenshots/mysql-persistence.png)

---

## 🚀 90 Days of DevOps

**Day 60/90 completed!**

10 days of Kubernetes learning → 1 complete capstone application.

#90DaysOfDevOps #DevOpsKaJosh #TrainWithShubham #Kubernetes #DevOps #Docker #WordPress #MySQL #CloudComputing

