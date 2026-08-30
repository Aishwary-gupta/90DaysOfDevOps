# Day 59 – Helm — Kubernetes Package Manager

## 📌 Overview

Today I learned **Helm**, the package manager for Kubernetes.

Over the previous Kubernetes days, I created Deployments, Services, ConfigMaps, Secrets, PVCs, StatefulSets, and other resources using individual YAML manifests. Managing many YAML files can become difficult as an application grows.

Helm solves this problem by packaging Kubernetes resources into reusable **Charts**.

> Helm is to Kubernetes what package managers such as `apt` are to Linux — it simplifies installing, configuring, upgrading, and removing applications.

---

## 🎯 Objectives

* Install Helm
* Add and search the Bitnami Helm repository
* Deploy an NGINX application using a Helm chart
* Customize a Helm release using `--set` and a values file
* Upgrade and rollback a release
* Create a custom Helm chart
* Validate and render a chart
* Upgrade the custom chart
* Clean up Helm releases

---

# 1. What is Helm?

**Helm** is a package manager for Kubernetes.

Instead of manually creating multiple Kubernetes YAML files, Helm allows us to package Kubernetes resources into a reusable chart.

For example, an application might require:

```text
Deployment
Service
ConfigMap
Secret
Ingress
PVC
ServiceAccount
```

Without Helm, each resource would normally need its own YAML configuration.

With Helm, these resources can be packaged into a single **Chart**.

### Benefits of Helm

* Simplifies Kubernetes application deployment
* Provides reusable templates
* Supports configuration through values
* Makes upgrades easier
* Provides release history
* Allows rollback to previous versions
* Makes application deployment repeatable

---

# 2. Three Core Helm Concepts

## Chart

A **Chart** is a package containing Kubernetes resource templates and configuration.

Example:

```text
bitnami/nginx
```

A chart can contain:

```text
Chart.yaml
values.yaml
templates/
```

---

## Release

A **Release** is a specific installation of a chart.

For example:

```bash
helm install my-nginx bitnami/nginx
```

Here:

* `bitnami/nginx` → Chart
* `my-nginx` → Release name

The same chart can therefore be installed multiple times using different release names.

---

## Repository

A **Repository** is a location containing Helm charts.

For example, Bitnami provides a large collection of Kubernetes application charts.

```text
bitnami/nginx
bitnami/mysql
bitnami/redis
...
```

---

# 3. Installing Helm

I verified that Helm was installed successfully.

### Verify Helm version

```bash
helm version
```

Example:

```text
version.BuildInfo{
    Version:"v3.x.x",
    ...
}
```

### Check Helm environment

```bash
helm env
```

This displays Helm-related environment variables and configuration paths.

### Verify Kubernetes connection

Before deploying a chart, I also verified that Kubernetes was accessible:

```bash
kubectl get nodes
```

---

# 4. Add the Bitnami Repository

I added the Bitnami Helm repository:

```bash
helm repo add bitnami https://charts.bitnami.com/bitnami
```

Then updated the repository index:

```bash
helm repo update
```

### Search for NGINX

```bash
helm search repo nginx
```

### Search Bitnami charts

```bash
helm search repo bitnami
```

Helm can now search the charts available from the Bitnami repository.

---

# 5. Deploy NGINX Using Helm

I deployed NGINX using the Bitnami chart:

```bash
helm install my-nginx bitnami/nginx
```

Here:

```text
my-nginx       → Release name
bitnami/nginx  → Chart
```

### Check Kubernetes resources

```bash
kubectl get all
```

To specifically check Pods:

```bash
kubectl get pods
```

To check Services:

```bash
kubectl get svc
```

---

# 6. Inspect the Helm Release

### List releases

```bash
helm list
```

### Check release status

```bash
helm status my-nginx
```

### View generated Kubernetes manifests

```bash
helm get manifest my-nginx
```

This demonstrates an important advantage of Helm: a single installation command can generate and manage multiple Kubernetes resources.

---

# 7. Customize a Helm Chart

Helm charts use a `values.yaml` file to provide configurable values.

I first inspected the default values for the Bitnami NGINX chart:

```bash
helm show values bitnami/nginx
```

Individual values can be overridden using `--set`.

For example:

```bash
helm install custom-nginx bitnami/nginx \
  --set replicaCount=3 \
  --set service.type=NodePort
```

This creates a release with:

```text
Replicas: 3
Service: NodePort
```

---

# 8. Using a Custom Values File

Instead of specifying multiple `--set` options, configuration can be stored in a YAML file.

## `custom-values.yaml`

```yaml
replicaCount: 3

service:
  type: NodePort

resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 250m
    memory: 256Mi
```

### Explanation

### `replicaCount`

```yaml
replicaCount: 3
```

Runs three NGINX replicas.

### Service type

```yaml
service:
  type: NodePort
```

Exposes the application through a Kubernetes NodePort service.

### Resource requests

```yaml
requests:
  cpu: 100m
  memory: 128Mi
```

These specify the minimum resources requested by the containers.

### Resource limits

```yaml
limits:
  cpu: 250m
  memory: 256Mi
```

These specify the maximum CPU and memory the container can consume.

---

## Install using the values file

```bash
helm install custom-nginx bitnami/nginx -f custom-values.yaml
```

Check the configured values:

```bash
helm get values custom-nginx
```

Check the Pods:

```bash
kubectl get pods
```

Check the Service:

```bash
kubectl get svc
```

The release should have:

```text
3 replicas
Service type: NodePort
```

---

# 9. Upgrade a Helm Release

Helm allows an existing release to be modified without reinstalling it.

I upgraded the original NGINX release to five replicas:

```bash
helm upgrade my-nginx bitnami/nginx --set replicaCount=5
```

Check the Pods:

```bash
kubectl get pods
```

The deployment should now have five replicas.

---

# 10. Helm Release History

Helm maintains revision history for releases.

I checked the history using:

```bash
helm history my-nginx
```

Example:

```text
REVISION    STATUS
1           deployed
2           deployed
```

Revision 1 represents the initial installation.

Revision 2 represents the upgrade.

---

# 11. Rollback

If an upgrade causes problems, Helm allows us to return to a previous revision.

I rolled the release back to revision 1:

```bash
helm rollback my-nginx 1
```

Then checked the history again:

```bash
helm history my-nginx
```

The important point is that Helm does **not** delete revision 2.

Instead, rollback creates another revision.

Example:

```text
REVISION    STATUS
1           superseded
2           superseded
3           deployed
```

So after one upgrade and one rollback, there are **3 revisions**.

---

# 12. Creating a Custom Helm Chart

Helm provides a command to scaffold a new chart:

```bash
helm create my-app
```

This creates a directory structure similar to:

```text
my-app/
├── Chart.yaml
├── values.yaml
├── charts/
├── templates/
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   ├── serviceaccount.yaml
│   ├── _helpers.tpl
│   └── tests/
└── .helmignore
```

---

# 13. Important Helm Chart Files

## Chart.yaml

Contains metadata about the chart.

Example:

```yaml
apiVersion: v2
name: my-app
description: A Helm chart for my Kubernetes application
type: application
version: 0.1.0
appVersion: "1.0"
```

---

## values.yaml

Contains default configuration values.

For this task, I configured:

```yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.25"
```

The values can then be referenced by templates.

---

## templates/

This directory contains Kubernetes YAML templates.

For example:

```text
templates/deployment.yaml
templates/service.yaml
templates/ingress.yaml
```

Instead of hardcoding values, Helm templates can dynamically use values from `values.yaml`.

---

# 14. Helm Go Templates

Helm uses the Go template language.

For example:

```yaml
replicas: {{ .Values.replicaCount }}
```

The value comes from:

```yaml
replicaCount: 3
```

Therefore Helm renders:

```yaml
replicas: 3
```

Another example:

```text
{{ .Chart.Name }}
```

returns the chart name.

And:

```text
{{ .Release.Name }}
```

returns the name of the installed release.

### Common Helm template objects

| Expression                 | Meaning                          |
| -------------------------- | -------------------------------- |
| `{{ .Values.key }}`        | Reads a value from `values.yaml` |
| `{{ .Chart.Name }}`        | Chart name                       |
| `{{ .Release.Name }}`      | Release name                     |
| `{{ .Release.Namespace }}` | Release namespace                |

---

# 15. Configure the Custom Chart

I modified `values.yaml`:

```yaml
replicaCount: 3

image:
  repository: nginx
  tag: "1.25"
```

This configures the application to use:

```text
Image: nginx:1.25
Replicas: 3
```

---

# 16. Validate the Chart

Before installing the chart, I used:

```bash
helm lint my-app
```

A successful validation produces output similar to:

```text
1 chart(s) linted, 0 chart(s) failed
```

This helps identify chart structure and template problems before deployment.

---

# 17. Preview the Rendered Kubernetes YAML

Helm can render the templates without installing anything into Kubernetes.

```bash
helm template my-release ./my-app
```

This is useful for debugging and understanding what Kubernetes manifests Helm will generate.

---

# 18. Install the Custom Chart

I installed the custom chart:

```bash
helm install my-release ./my-app
```

Then verified the Pods:

```bash
kubectl get pods
```

Expected:

```text
3 replicas
```

---

# 19. Upgrade the Custom Chart

I upgraded the release to five replicas:

```bash
helm upgrade my-release ./my-app --set replicaCount=5
```

Then checked:

```bash
kubectl get pods
```

Expected:

```text
5 replicas
```

This demonstrates how Helm can manage application configuration throughout its lifecycle.

---

# 20. Helm vs Kubernetes YAML

| Kubernetes YAML                              | Helm                      |
| -------------------------------------------- | ------------------------- |
| Manifests are often static                   | Uses reusable templates   |
| Configuration can be duplicated              | Values can be centralized |
| Manual upgrades                              | `helm upgrade`            |
| Rollback requires managing resources/history | `helm rollback`           |
| Many YAML files                              | One reusable chart        |
| Harder to reuse                              | Charts can be shared      |

---

# 21. Cleanup

After completing the experiments, I removed the Helm releases.

```bash
helm uninstall my-nginx
helm uninstall custom-nginx
helm uninstall my-release
```

Then verified:

```bash
helm list
```

The expected result is no active Helm releases.

If release history needs to be retained while uninstalling, Helm also supports:

```bash
helm uninstall <release-name> --keep-history
```

---

# 22. Useful Helm Commands

| Command             | Purpose                       |
| ------------------- | ----------------------------- |
| `helm version`      | Check Helm version            |
| `helm env`          | Display Helm environment      |
| `helm repo add`     | Add a repository              |
| `helm repo update`  | Update repository information |
| `helm search repo`  | Search charts                 |
| `helm install`      | Install a chart               |
| `helm list`         | List releases                 |
| `helm status`       | Show release status           |
| `helm show values`  | Display chart defaults        |
| `helm get values`   | Display release values        |
| `helm get manifest` | Display generated manifests   |
| `helm upgrade`      | Upgrade a release             |
| `helm history`      | View release revisions        |
| `helm rollback`     | Roll back a release           |
| `helm create`       | Create a chart                |
| `helm lint`         | Validate a chart              |
| `helm template`     | Render templates locally      |
| `helm uninstall`    | Remove a release              |

---

# 23. What I Learned

Today I learned how Helm simplifies Kubernetes application management.

The major concepts I practiced were:

* Helm Charts
* Helm Releases
* Helm Repositories
* Bitnami charts
* `values.yaml`
* `--set` overrides
* Helm upgrades
* Release history
* Rollbacks
* Custom chart creation
* Go templating
* `helm lint`
* `helm template`

The biggest takeaway is that Helm allows Kubernetes applications to be packaged as reusable, configurable units instead of managing every YAML manifest independently.

---

# 24. Final Verification

### Helm

```bash
helm version
helm env
```

### Repository

```bash
helm repo list
helm search repo nginx
```

[O### Releases

```bash
helm list
```

### Kubernetes

```bash
kubectl get pods
kubectl get svc
```

### Custom Chart

```bash
helm lint my-app
helm template my-release ./my-app
```

### Release History

```bash
helm history my-nginx
```

---

## 📁 Day 59 Submission Structure

```text
2026/
└── day-59/
    ├── day-59-helm.md
    ├── custom-values.yaml
    └── my-app/
        ├── Chart.yaml
        ├── values.yaml
        ├── charts/
        └── templates/
```

---

## 🚀 Day 59 Complete

**Topics covered:** Helm → Charts → Repositories → Releases → Values → Upgrades → Rollbacks → Custom Charts → Go Templates

**Key takeaway:**

> Helm turns complex Kubernetes deployments into reusable, configurable, and versioned application packages.

