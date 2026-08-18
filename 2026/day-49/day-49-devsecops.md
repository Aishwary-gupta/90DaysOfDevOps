# Day 49 – DevSecOps: Securing the CI/CD Pipeline

## Overview

Today I added security checks to the CI/CD pipeline I built during Day 48.

The goal of DevSecOps is to make security part of the development and deployment process instead of treating it as a separate activity performed after deployment.

My pipeline now checks dependencies, scans Docker images for known vulnerabilities, protects repository secrets, and uses least-privilege GitHub Actions permissions.

---

# What is DevSecOps?

DevSecOps means integrating security into the software development and CI/CD lifecycle.

Instead of building and deploying first and checking security later, security checks are automated inside the pipeline so vulnerabilities can be detected earlier.

The main idea I learned today is:

> Build → Test → Secure → Deploy

Security is not a separate stage performed only at the end. It is continuously included in the development workflow.

---

# What I Added Today

I added four major security improvements:

1. Docker image vulnerability scanning using Trivy
2. GitHub Secret Scanning and Push Protection
3. Dependency vulnerability checking using Dependency Review
4. Least-privilege permissions for GitHub Actions workflows

---

# 1. Docker Image Scanning with Trivy

After building the Docker image, I added a Trivy security scan before pushing the image to Docker Hub.

The relevant workflow step is:

```yaml
- name: Scan Docker Image for Vulnerabilities
  uses: aquasecurity/trivy-action@master
  with:
    image-ref: '${{ secrets.DOCKER_USERNAME }}/myapp:latest'
    format: 'table'
    exit-code: '1'
    severity: 'CRITICAL,HIGH'
```

## Why Trivy?

Docker images contain more than my application code.

They can contain:

* Base operating-system packages
* System libraries
* Application dependencies
* Other software components

Some of these components may contain publicly known vulnerabilities.

Trivy scans the image and compares detected packages against vulnerability information.

---

## Why does the scan happen before Docker Push?

The pipeline follows:

```text
Docker Build
     ↓
Trivy Scan
     ↓
Security Check
     ↓
Docker Push
```

If HIGH or CRITICAL vulnerabilities are detected, Trivy returns exit code `1`.

This causes the workflow to fail and prevents the following Docker Push step from running.

This is an example of security being used as a deployment gate.

---

## Trivy Configuration

### image-ref

Specifies the Docker image that should be scanned.

### format

I used:

```yaml
format: 'table'
```

This produces a readable vulnerability table in the GitHub Actions logs.

### severity

I used:

```yaml
severity: 'CRITICAL,HIGH'
```

The scan focuses on HIGH and CRITICAL vulnerabilities for this exercise.

### exit-code

I used:

```yaml
exit-code: '1'
```

This causes the workflow step to fail when vulnerabilities matching the selected severity are found.

---

## Trivy Scan Result

> Replace this section with my actual result after running the workflow.

**Result:** PASS / FAIL

**Base image used:**

```text
[Write your actual Docker base image here]
```

**Vulnerabilities found:**

```text
[Write the actual number and severity from the Trivy output]
```

### Screenshot

Add the screenshot of the Trivy scan output below:

```text
[INSERT TRIVY GITHUB ACTIONS SCREENSHOT HERE]
```

---

# 2. GitHub Secret Scanning

I enabled GitHub's secret security features for the repository.

Secret scanning helps detect exposed credentials such as:

* API keys
* Cloud credentials
* Tokens
* Passwords
* Other supported secrets

The purpose is to prevent credentials from being accidentally committed to source control.

---

# Secret Scanning vs Push Protection

## Secret Scanning
OAOAOA
Secret scanning detects supported secrets that are present in repository content and generates security alerts.

Conceptually:

```text
Secret exposed
      ↓
GitHub scans repository
      ↓
Secret detected
      ↓
Security alert
      ↓
Developer investigates and fixes it
```

## Push Protection

Push protection attempts to stop supported secrets before they reach the repository.

Conceptually:

```text
Developer commits secret
        ↓
GitHub detects secret
        ↓
Push blocked
        ↓
Developer removes secret
```

Therefore:

> Secret scanning focuses on detection, while push protection focuses on prevention.

---

# What happens if an AWS credential is leaked?

If a supported AWS credential is detected, GitHub can generate a security alert, and push protection can block the push when enabled.

If a real credential has already been exposed, simply deleting it from the latest version of the file is not enough.

The credential should be treated as compromised and rotated/revoked.

For this reason, real cloud credentials should never be committed to the repository.

---

# 3. Dependency Review

I added GitHub's Dependency Review Action to the Pull Request workflow.

```yaml
- name: Dependency Review
  uses: actions/dependency-review-action@v4
  with:
    fail-on-severity: critical
```

The purpose is to detect security vulnerabilities introduced through dependency changes in a Pull Request.

For example:

```text
Developer adds dependency
          ↓
Pull Request
          ↓
Dependency Review
          ↓
Known critical vulnerability?
       /          \
     YES           NO
      ↓             ↓
    FAIL           PASS
```

This allows security issues to be detected before the Pull Request is merged.

---

# Why Dependency Review belongs in the PR pipeline

A Pull Request is an ideal place to perform this check because the code has not yet been merged into the main branch.

The security principle is:

> Find the problem before it becomes part of the main application.

This is another example of shifting security left.

---

# 4. GitHub Actions Permissions

I also added least-privilege permissions to my workflows.

Example:

```yaml
permissions:
  contents: read
```

The principle is:

> Give a workflow only the permissions it actually needs.

A workflow does not automatically need write access to the entire repository.

If a third-party action or workflow were compromised and had excessive permissions, those permissions could potentially be abused.

Therefore, limiting permissions reduces the potential impact of a compromised workflow.

---

# Security Layers Added

My Day 49 pipeline now has multiple security layers:

```text
                    CI/CD Pipeline
                          │
          ┌───────────────┼────────────────┐
          │               │                │
          ▼               ▼                ▼
   Secret Security   Dependencies    Container Security
          │               │                │
          ▼               ▼                ▼
 Secret Scanning    Dependency       Trivy
 Push Protection      Review         Image Scan
```

In addition, GitHub Actions workflows use:

```text
Least-Privilege Permissions
```

---

# Complete Secure Pipeline

```text
Developer
    │
    ▼
Pull Request
    │
    ├── Build
    │
    ├── Test
    │
    └── Dependency Review
            │
        PASS / FAIL
            │
            ▼
          MERGE
            │
            ▼
       Main Branch
            │
            ▼
       Build + Test
            │
            ▼
      Docker Build
            │
            ▼
      Trivy Scan
            │
       ┌────┴────┐
       │         │
     FAIL       PASS
       │         │
       ▼         ▼
      STOP    Docker Push
                 │
                 ▼
               Deploy


GitHub Secret Scanning
          +
    Push Protection
          ↓
Protect repository secrets

GitHub Actions Permissions
          ↓
Apply least privilege
```

---

# What I Learned

## 1. Security should be automated

Security checks should not depend only on developers remembering to run them manually.

CI/CD provides an ideal place to automate security checks.

---

## 2. Vulnerabilities should be caught early

Finding a vulnerability during a Pull Request is much easier than finding it after deployment.

This is the idea of shifting security left.

---

## 3. Docker images also need security scanning

Even if application code is correct, the Docker base image or installed packages can contain known vulnerabilities.

Therefore, container images should also be scanned.

---

## 4. Secrets should never be stored in source code

Credentials should be stored using secure mechanisms such as GitHub Secrets or short-lived identity mechanisms such as OIDC where appropriate.

A `.env` file containing real credentials should never be committed.

---

## 5. Least privilege matters

GitHub Actions workflows should receive only the permissions they require.

This reduces the potential damage if a workflow or third-party action becomes compromised.

---

# DevSecOps Pipeline Summary

Before Day 49:

```text
Build → Test → Docker Build → Push → Deploy
```

After Day 49:

```text
PR
 ↓
Build
 ↓
Test
 ↓
Dependency Security Check
 ↓
Merge
 ↓
Build
 ↓
Docker Build
 ↓
Trivy Security Scan
 ↓
Docker Push
 ↓
Deploy
```

Alongside the pipeline:

```text
Secret Scanning
+
Push Protection
+
Least-Privilege Permissions
```

My CI/CD pipeline has now evolved into a basic DevSecOps pipeline where security checks are automatically integrated into the software delivery process.

---

# Files Changed

```text
.github/
└── workflows/
    ├── [existing CI workflow]
    ├── [existing CD workflow]
    └── dependency-review.yml
```

---

# Day 49 Outcome

I successfully added automated security checks to my CI/CD pipeline.

The major concepts I practiced were:

* DevSecOps
* Shift-left security
* Docker image vulnerability scanning
* Trivy
* CVEs
* Secret scanning
* Push protection
* Dependency Review
* GitHub Actions permissions
* Least privilege
* Security gates in CI/CD

This means security is no longer something considered only after deployment. It is now part of the automated development and deployment workflow.

