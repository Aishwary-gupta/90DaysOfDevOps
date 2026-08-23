# Day 54 – Kubernetes ConfigMaps and Secrets

## Overview

Today I learned how Kubernetes manages application configuration using **ConfigMaps** and **Secrets**.

Instead of hardcoding configuration values inside container images, Kubernetes allows applications to consume configuration dynamically through environment variables and mounted files.

I worked with:

* ConfigMaps created from literals
* ConfigMaps created from files
* ConfigMaps consumed as environment variables
* ConfigMaps mounted as files
* Kubernetes Secrets
* Secrets consumed through environment variables
* Secrets mounted as files
* ConfigMap update propagation
* The difference between Base64 encoding and encryption

---

## Objectives

* Understand ConfigMaps
* Understand Kubernetes Secrets
* Create ConfigMaps from command-line literals
* Create ConfigMaps from configuration files
* Inject ConfigMap values as environment variables
* Mount ConfigMaps as volumes
* Create and consume Secrets
* Decode Base64-encoded Secret values
* Observe ConfigMap volume update propagation

---

# 1. ConfigMaps

A ConfigMap is a Kubernetes object used to store **non-sensitive configuration data**.

Examples include:

* Application environment
* Feature flags
* Port numbers
* Configuration files
* Application settings

ConfigMaps should not be used for passwords, API keys, tokens, or other sensitive information.

---

## Creating a ConfigMap from Literals

I created `app-config` using:

```bash
kubectl create configmap app-config \
  --from-literal=APP_ENV=production \
  --from-literal=APP_DEBUG=false \
  --from-literal=APP_PORT=8080
```

The ConfigMap contains:

```text
APP_ENV=production
APP_DEBUG=false
APP_PORT=8080
```

I inspected it using:

```bash
kubectl describe configmap app-config
```

and:

```bash
kubectl get configmap app-config -o yaml
```

The values are stored as readable configuration data.

---

# 2. ConfigMap from a File

I created an Nginx configuration file:

```text
nginx/default.conf
```

The configuration provides a `/health` endpoint:

```nginx
location /health {
    default_type text/plain;
    return 200 "healthy\n";
}
```

I created the ConfigMap with:

```bash
kubectl create configmap nginx-config \
  --from-file=default.conf=nginx/default.conf
```

The file was then mounted into an Nginx Pod at:

```text
/etc/nginx/conf.d/default.conf
```

---

# 3. ConfigMap as Environment Variables

I used `envFrom` to inject all keys from `app-config`:

```yaml
envFrom:
  - configMapRef:
      name: app-config
```

The container received:

```text
APP_ENV=production
APP_DEBUG=false
APP_PORT=8080
```

This approach is useful for simple key-value application settings.

---

# 4. ConfigMap as a Volume

For the Nginx configuration, I used a ConfigMap volume:

```yaml
volumes:
  - name: nginx-config-volume
    configMap:
      name: nginx-config
```

The volume was mounted at:

```text
/etc/nginx/conf.d
```

The ConfigMap key:

```text
default.conf
```

became a file inside the container:

```text
/etc/nginx/conf.d/default.conf
```

I verified the Nginx health endpoint and received:

```text
healthy
```

---

# 5. Kubernetes Secrets

Secrets are Kubernetes objects intended for sensitive configuration data.

Examples include:

* Database passwords
* API tokens
* Credentials
* Authentication information

I created a Secret called `db-credentials`:

```bash
kubectl create secret generic db-credentials \
  --from-literal=DB_USER=admin \
  --from-literal='DB_PASSWORD=s3cureP@ssw0rd'
```

I inspected it using:

```bash
kubectl get secret db-credentials -o yaml
```

The values appeared as Base64-encoded strings.

---

# 6. Base64 Is Not Encryption

One of the most important concepts I learned today is:

> Base64 encoding is not encryption.

For example:

```text
admin
```

can be represented as:

```text
YWRtaW4=
```

Anyone who has access to the Base64 value can decode it.

I decoded the Secret using:

```bash
kubectl get secret db-credentials \
  -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
```

The original value was returned:

```text
s3cureP@ssw0rd
```

Kubernetes Secrets provide mechanisms for separating sensitive configuration through Kubernetes access controls, and clusters can also be configured for encryption at rest.

---

# 7. Using Secrets as Environment Variables

I injected `DB_USER` using `secretKeyRef`:

```yaml
env:
  - name: DB_USER
    valueFrom:
      secretKeyRef:
        name: db-credentials
        key: DB_USER
```

Inside the container:

```bash
echo $DB_USER
```

returned:

```text
admin
```

---

# 8. Mounting Secrets as Files

I also mounted the complete Secret:

```yaml
volumeMounts:
  - name: db-credentials-volume
    mountPath: /etc/db-credentials
    readOnly: true
```

Each Secret key became a file:

```text
/etc/db-credentials/DB_USER
/etc/db-credentials/DB_PASSWORD
```

Reading these files returned the decoded plaintext values.

For example:

```bash
cat /etc/db-credentials/DB_PASSWORD
```

returned:

```text
s3cureP@ssw0rd
```

The mounted file is not Base64 text.

---

# 9. ConfigMap Update Propagation

I created:

```text
live-config
```

with:

```text
message=hello
```

The ConfigMap was mounted as a volume in a Pod.

The Pod continuously read:

```text
/etc/live-config/message
```

I then updated the ConfigMap:

```bash
kubectl patch configmap live-config \
  --type merge \
  -p '{"data":{"message":"world"}}'
```

After waiting for Kubernetes to refresh the mounted volume, the Pod began reading:

```text
world
```

without restarting the Pod.

---

# 10. Environment Variables vs Volume Mounts

| Method               | ConfigMap/Secret changes automatically reflected? |
| -------------------- | ------------------------------------------------- |
| Environment variable | No                                                |
| Volume-mounted file  | Yes, after Kubernetes refreshes the volume        |

Environment variables are established when the container starts.

Volume-mounted ConfigMaps and Secrets are periodically refreshed by Kubernetes.

This makes volume mounts useful for configuration files or values that may need to change without recreating the Pod.

---

# 11. Important Commands

### List ConfigMaps

```bash
kubectl get configmaps
```

### Inspect ConfigMap

```bash
kubectl get configmap app-config -o yaml
```

### List Secrets

```bash
kubectl get secrets
```

### Inspect Secret

```bash
kubectl get secret db-credentials -o yaml
```

### Decode Secret

```bash
kubectl get secret db-credentials \
  -o jsonpath='{.data.DB_PASSWORD}' | base64 --decode
```

### Create ConfigMap from literal

```bash
kubectl create configmap app-config \
  --from-literal=KEY=VALUE
```

### Create ConfigMap from file

```bash
kubectl create configmap nginx-config \
  --from-file=default.conf=nginx/default.conf
```

### Patch ConfigMap

```bash
kubectl patch configmap live-config \
  --type merge \
  -p '{"data":{"message":"world"}}'
```

---

# 12. What I Learned

The main lessons from Day 54 were:

1. ConfigMaps store non-sensitive configuration.
2. Secrets are intended for sensitive configuration.
3. ConfigMaps can be consumed as environment variables.
4. ConfigMaps can also be mounted as files.
5. Secrets can be injected using `secretKeyRef`.
6. Secrets can be mounted as files.
7. Base64 is encoding, not encryption.
8. Environment variables do not automatically change when a ConfigMap changes.
9. Volume-mounted ConfigMaps can be updated automatically.
10. Configuration should be separated from application container images.

---

# Conclusion

Day 54 helped me understand how Kubernetes separates application configuration from container images.

I practiced both environment-variable based configuration and file-based configuration using ConfigMaps. I also learned how Kubernetes Secrets are consumed and why Base64 should never be confused with encryption.

The most important takeaway was understanding the different update behavior between environment variables and volume-mounted configuration.

**ConfigMaps → non-sensitive configuration**

**Secrets → sensitive configuration**

**Environment variables → fixed when the container starts**

**Volume mounts → can receive configuration updates without a Pod restart**

