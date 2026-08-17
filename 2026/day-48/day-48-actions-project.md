# Day 48 – GitHub Actions End-to-End CI/CD Pipeline

## 🚀 Overview

Today I combined everything I learned from **Day 40 to Day 47** into one complete GitHub Actions project.

The goal was to build a production-style CI/CD pipeline that automatically **tests, builds, scans, pushes, deploys, and monitors** a Dockerized application.

This project demonstrates how individual GitHub Actions concepts can work together as a complete DevOps workflow.

---

# 🏗️ Pipeline Architecture

```text
                    ┌─────────────────────┐
                    │   Developer Push    │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │    Pull Request     │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Build & Test       │
                    │ Reusable Workflow   │
                    └──────────┬──────────┘
                               │
                         Tests Passed
                               │
                               ▼
                    ┌─────────────────────┐
                    │    PR Checks Pass   │
                    └──────────┬──────────┘
                               │
                         Merge to main
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Build & Test       │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Docker Build       │
                    │  & Push to Hub      │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │  Security Scan      │
                    │     Trivy           │
                    └──────────┬──────────┘
                               │
                               ▼
                    ┌─────────────────────┐
                    │      Deploy         │
                    │    Production       │
                    └─────────────────────┘


             Every 12 Hours
                    │
                    ▼
          ┌─────────────────────┐
          │    Health Check     │
          │ Pull → Run → Curl   │
          └─────────────────────┘
```

---

# 📁 Project Structure

```text
github-actions-capstone/
│
├── app/
│   └── app.py
│
├── tests/
│   └── test_app.py
│
├── Dockerfile
├── requirements.txt
├── README.md
│
└── .github/
    └── workflows/
        ├── reusable-build-test.yml
        ├── reusable-docker.yml
        ├── pr-pipeline.yml
        ├── main-pipeline.yml
        └── health-check.yml
```

---

# 🔄 Workflows Created

## 1. Reusable Build & Test Workflow

**File:** `.github/workflows/reusable-build-test.yml`

Created a reusable workflow using:

```yaml
on:
  workflow_call:
```

It accepts:

* `python_version`
* `run_tests`

The workflow:

1. Checks out the repository
2. Sets up Python
3. Installs dependencies
4. Runs tests
5. Reports the test result

This workflow can be reused by multiple pipelines instead of duplicating CI logic.

---

## 2. Reusable Docker Workflow

**File:** `.github/workflows/reusable-docker.yml`

Created another reusable workflow for Docker operations.

It accepts:

* `image_name`
* `tag`

And securely receives:

* Docker Hub username
* Docker Hub token

The workflow:

1. Checks out the code
2. Logs into Docker Hub
3. Builds the Docker image
4. Pushes the image
5. Generates the image URL as an output

---

# 🔍 3. Pull Request Pipeline

**File:** `.github/workflows/pr-pipeline.yml`

The PR pipeline runs when a Pull Request targets `main`.

```text
Pull Request
     │
     ▼
Build & Test
     │
     ▼
PR Checks
```

The important design decision is:

> **Docker images are NOT built or pushed during Pull Request validation.**

This keeps PR validation fast and avoids unnecessary Docker registry operations.

---

# 🚀 4. Main Branch Pipeline

**File:** `.github/workflows/main-pipeline.yml`

When code is merged into `main`, the complete pipeline runs:

```text
Push to main
     │
     ▼
Build & Test
     │
     ▼
Docker Build & Push
     │
     ▼
Security Scan
     │
     ▼
Production Deploy
```

Docker images are tagged using:

```text
latest
sha-<short-commit>
```

The deployment job uses:

```yaml
environment: production
```

This allows GitHub Environment protection rules and manual approvals to be added.

---

# 🔐 5. DevSecOps – Image Security

As an additional security step, I integrated **Trivy** into the pipeline.

The Docker image is scanned for known vulnerabilities before deployment.

The pipeline can be configured to fail when **CRITICAL vulnerabilities** are detected.

The scan report is also uploaded as a workflow artifact.

This introduces security directly into the CI/CD pipeline instead of treating security as a separate process.

---

# ❤️ 6. Scheduled Health Check

**File:** `.github/workflows/health-check.yml`

The health-check workflow runs every 12 hours:

```text
0 */12 * * *
```

It can also be triggered manually using:

```yaml
workflow_dispatch:
```

The workflow:

1. Pulls the latest Docker image
2. Starts the container
3. Waits for the application to start
4. Calls the health endpoint
5. Reports PASS/FAIL
6. Stops and removes the container
7. Generates a GitHub Actions summary

Example summary:

```text
## Health Check Report

- Image: myapp:latest
- Status: PASSED
- Time: <timestamp>
```

---

# 🔑 GitHub Actions Concepts Used

This project combines several concepts learned throughout the previous days:

* GitHub Actions workflows
* `push`
* `pull_request`
* `workflow_call`
* `workflow_dispatch`
* Reusable workflows
* Workflow inputs
* Workflow outputs
* GitHub Secrets
* Docker builds
* Docker Hub
* GitHub Environments
* Environment protection
* Job dependencies
* Conditional execution
* Artifacts
* `$GITHUB_STEP_SUMMARY`
* Scheduled workflows
* Health checks
* Security scanning with Trivy

---

# 🛡️ Secrets & Security

Sensitive credentials are not stored directly inside workflow files.

The pipeline uses GitHub Secrets for:

```text
DOCKER_USERNAME
DOCKER_TOKEN
```

This keeps authentication credentials outside the source code.

For production deployments, GitHub Environment protection can also require manual approval before deployment.

---

# 🏷️ Docker Image Strategy

The pipeline creates two useful tags:

```text
myusername/myapp:latest
myusername/myapp:sha-abcdef1
```

### `latest`

Points to the most recent successful image.

### Commit SHA

Provides an immutable reference to the exact version of the application.

This makes it easier to identify and roll back to a specific build.

---

# 📊 Pipeline Benefits

This architecture provides:

### Faster Pull Request Feedback

Every PR gets automated testing before merging.

### Automated Builds

Docker images are automatically built after changes reach `main`.

### Consistent Deployments

The same Docker image produced by CI is used for deployment.

### Security

Images can be scanned for vulnerabilities before deployment.

### Monitoring

Scheduled health checks verify that the container can start and respond correctly.

### Reusability

Common CI/CD logic is stored in reusable workflows rather than duplicated.

---

# 🧪 Verification

* [ ] Application runs locally
* [ ] Docker image builds successfully
* [ ] Application tests pass
* [ ] PR pipeline runs successfully
* [ ] PR pipeline does not push Docker images
* [ ] Main pipeline runs after merge
* [ ] Docker image is pushed to Docker Hub
* [ ] Image receives `latest` tag
* [ ] Image receives SHA-based tag
* [ ] Security scan runs
* [ ] Production environment is configured
* [ ] Deployment job runs successfully
* [ ] Scheduled health check works
* [ ] Manual health check tested
* [ ] GitHub Actions summary generated
* [ ] Workflow status badges added
* [ ] PR pipeline screenshot added
* [ ] Main pipeline screenshot added

---

# 📸 Screenshots

### Pull Request Pipeline

*Add screenshot of the PR validation workflow running.*

### Main Branch Pipeline

*Add screenshot showing:*

```text
Build & Test → Docker Build & Push → Security Scan → Deploy
```

### Health Check

*Add screenshot of the scheduled/manual health-check result.*

---

# 🔗 Docker Hub

Docker image:

`<ADD-YOUR-DOCKER-HUB-IMAGE-LINK-HERE>`

---

# 🚀 What I Would Add Next

If this were a real production project, I would improve the pipeline by adding:

* Slack/Teams deployment notifications
* Separate Development, Staging, and Production environments
* Automated rollback
* Kubernetes deployment
* Blue-Green or Canary deployments
* Infrastructure as Code with Terraform
* Dependency vulnerability scanning
* Secret scanning
* Application performance monitoring
* Centralized logging
* Deployment metrics and dashboards

---

# 🎯 Key Takeaway

Day 48 was about moving from **learning individual GitHub Actions features to designing a complete CI/CD system**.

The final pipeline follows a simple production-style flow:

```text
PR → Test → Validate
          ↓
       Merge
          ↓
   Test → Build → Scan → Push → Deploy
                              ↓
                       Health Monitoring
```

The biggest lesson is that CI/CD is not just about automating commands.

It is about creating a **reliable software delivery process** where every change is tested, packaged, secured, deployed, and monitored automatically.

#90DaysOfDevOps #GitHubActions #CICD #DevOps

