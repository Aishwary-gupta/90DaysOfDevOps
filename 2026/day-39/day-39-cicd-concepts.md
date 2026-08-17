# Day 39 – CI/CD Concepts

## 1. Introduction

CI/CD stands for Continuous Integration and Continuous Delivery/Deployment.

CI/CD is not a single tool. It is a software engineering practice used to automate the process of integrating code, testing applications, building software, and delivering or deploying it.

Tools such as GitHub Actions, Jenkins, GitLab CI/CD and CircleCI can be used to implement CI/CD.

The main goal of CI/CD is to make software delivery faster, repeatable, reliable and less dependent on manual work.

---

# 2. The Problem CI/CD Solves

Imagine a team of five developers manually pushing and deploying code to production.

Several problems can occur:

* Developers can introduce bugs that affect other developers.
* Code may work on one developer's machine but fail in another environment.
* Developers may forget deployment steps.
* The wrong branch or version may be deployed.
* Dependencies or environment configurations may be different.
* Manual deployments are difficult to repeat consistently.
* Testing may happen too late.
* A bug may reach production before anyone notices it.
* Frequent manual deployments increase the possibility of human error.

## "It works on my machine"

"It works on my machine" means that an application works correctly in the developer's environment but fails in another environment such as testing, staging or production.

This can happen because environments may have different:

* Operating systems
* Programming language versions
* Dependencies
* Database versions
* Environment variables
* Network configurations
* System libraries

Docker can help reduce these differences by packaging an application and its dependencies into a container image.

## Manual deployment frequency

There is no universal number of manual deployments that is considered safe.

The main problem is that manual deployment does not scale reliably. Every manual deployment introduces another opportunity for human error.

Instead of asking how many deployments humans can safely perform, DevOps teams try to automate repetitive and error-prone deployment work.

---

# 3. Continuous Integration

Continuous Integration (CI) means developers frequently integrate their changes into a shared repository and automatically build and test those changes.

A typical CI process is:

```text
Developer
    ↓
git push
    ↓
Build
    ↓
Tests
    ↓
Feedback
```

CI helps detect problems early instead of discovering them after multiple changes have already been combined.

### Real-world example

A developer creates a pull request.

A CI pipeline automatically:

1. Checks out the code.
2. Installs dependencies.
3. Builds the application.
4. Runs unit tests.
5. Runs linting or other quality checks.

If the tests fail, the developer receives immediate feedback.

---

# 4. Continuous Delivery

Continuous Delivery extends CI by automatically preparing software so that it is always in a releasable state.

A typical flow is:

```text
Code
 ↓
Build
 ↓
Test
 ↓
Package
 ↓
Staging
 ↓
Ready for Production
```

Production deployment may still require human approval.

### Real-world example

A company automatically builds and tests every change and deploys successful builds to staging.

When the team wants to release the application to production, an authorized person approves the production deployment.

---

# 5. Continuous Deployment

Continuous Deployment goes one step further.

In Continuous Deployment, changes that successfully pass the required automated checks are automatically deployed to production without requiring manual approval for every deployment.

```text
Code
 ↓
Build
 ↓
Test
 ↓
Security Checks
 ↓
Deploy
 ↓
Production
```

### Real-world example

A high-velocity software team may have many small changes every day.

After automated testing and security checks pass, the system automatically deploys the change to production.

---

# 6. CI vs Continuous Delivery vs Continuous Deployment

| Concept                | Main Purpose                                           |
| ---------------------- | ------------------------------------------------------ |
| Continuous Integration | Automatically build and test integrated code           |
| Continuous Delivery    | Keep software ready for release                        |
| Continuous Deployment  | Automatically release successful changes to production |

The easiest way to remember the difference:

```text
CI
↓
Does the code work?

Continuous Delivery
↓
Is the software ready to release?

Continuous Deployment
↓
Can we release it automatically?
```

---

# 7. Pipeline Anatomy

## Trigger

A trigger is the event that starts a pipeline.

Examples:

* Push
* Pull request
* Scheduled time
* Release
* Tag
* Manual workflow dispatch

Example:

```yaml
on:
  push:
    branches:
      - main
```

This means a push to the main branch can start the workflow.

---

## Stage

A stage is a logical phase of a pipeline.

Examples:

```text
Build
Test
Deploy
```

Stages help organize the pipeline into meaningful phases.

---

## Job

A job is a unit of work inside a workflow.

For example, a test stage could contain:

```text
Unit Test Job
Integration Test Job
Security Scan Job
```

Some jobs can run in parallel.

---

## Step

A step is an individual command or action inside a job.

For example:

```text
Test Job
    ↓
Checkout code
    ↓
Install dependencies
    ↓
Run tests
```

---

## Runner

A runner is the machine or execution environment that runs a job.

For example:

```yaml
runs-on: ubuntu-latest
```

This tells GitHub Actions to execute the job on an Ubuntu runner.

---

## Artifact

An artifact is an output produced by a job that can be stored or used later.

Examples:

* ZIP files
* Build packages
* Test reports
* Coverage reports
* Compiled binaries
* Application packages

Example:

```text
Build Job
    ↓
application.zip
    ↓
Artifact
    ↓
Deploy Job
```

---

# 8. CI/CD Pipeline Diagram

Scenario:

A developer pushes code to GitHub. The application is tested, built into a Docker image and deployed to a staging server.

```text
                    DEVELOPER
                        │
                        │ git push
                        ▼
                ┌───────────────┐
                │    GitHub     │
                │   Repository  │
                └───────┬───────┘
                        │
                     Trigger
                        │
                        ▼
              ┌───────────────────┐
              │   STAGE 1: BUILD  │
              │                   │
              │ Checkout code     │
              │ Install deps      │
              │ Build application │
              └─────────┬─────────┘
                        │
                        ▼
              ┌───────────────────┐
              │   STAGE 2: TEST   │
              │                   │
              │ Unit tests        │
              │ Integration tests │
              │ Linting           │
              └─────────┬─────────┘
                        │
                    Tests pass
                        │
                        ▼
              ┌───────────────────┐
              │ STAGE 3: DOCKER   │
              │                   │
              │ docker build      │
              │ Tag image         │
              └─────────┬─────────┘
                        │
                        ▼
              ┌───────────────────┐
              │ STAGE 4: DEPLOY   │
              │                   │
              │ Deploy container  │
              │ to staging        │
              └─────────┬─────────┘
                        │
                        ▼
                ┌───────────────┐
                │ STAGING SERVER│
                │               │
                │ Docker        │
                │ Application   │
                └───────────────┘
```

---

# 9. Why Is the Pipeline Ordered This Way?

## Build

First we verify that the application can actually be built.

```text
Source Code
    ↓
Build
```

If the application cannot build, the pipeline should stop.

## Test

After building, we verify that the application behaves correctly.

```text
Build
 ↓
Tests
```

If tests fail:

```text
❌ Stop pipeline
```

There is no reason to deploy known-broken software.

## Docker

After successful validation, the application can be packaged into a Docker image.

```text
Application
+
Dependencies
+
Runtime
    ↓
Docker Image
```

## Staging

The image is then deployed to a staging environment where the application can be tested in a production-like environment before production deployment.

---

# 10. Pipeline Failure Is Not Necessarily Bad

A failed pipeline does not automatically mean CI/CD is broken.

For example:

```text
Developer Push
      ↓
Build ✅
      ↓
Tests ❌
      ↓
Pipeline stops
```

The pipeline successfully prevented a potentially broken application from moving further.

Therefore:

> A pipeline failing can be CI/CD doing its job.

The objective is not to make every pipeline green at any cost.

The objective is to get fast and reliable feedback and prevent bad changes from progressing.

---

# 11. Explore CI/CD in the Wild

Repository explored:

Kubernetes:

https://github.com/kubernetes/kubernetes

The Kubernetes repository uses GitHub Actions workflow files under:

```text
.github/workflows/
```

When exploring a workflow, inspect:

```yaml
on:
```

to identify the trigger.

Then inspect:

```yaml
jobs:
```

to identify the jobs.

Finally inspect:

```yaml
steps:
```

and commands such as:

```yaml
uses:
run:
```

to understand what the workflow does.

The important lesson is not to understand every line immediately.

Instead, identify:

```text
Trigger
   ↓
Jobs
   ↓
Steps
   ↓
Purpose
```

This is how a DevOps engineer can begin reverse-engineering an unfamiliar pipeline.

---

# 12. Key Takeaways

CI/CD is a practice, not a single tool.

```text
CI/CD
  │
  ├── Continuous Integration
  │       └── Build + Test
  │
  ├── Continuous Delivery
  │       └── Keep software ready to release
  │
  └── Continuous Deployment
          └── Automatically release changes
```

Pipeline terminology:

```text
Trigger
   ↓
Stage
   ↓
Job
   ↓
Step
   ↓
Runner
   ↓
Artifact
```

The overall goal is:

```text
Manual + inconsistent
          ↓
Automated + repeatable
          ↓
Fast feedback
          ↓
Reliable software delivery
```

---

# 13. What I Learned on Day 39

Today I learned that CI/CD is much more than writing GitHub Actions YAML.

I learned why manual deployments become risky as a development team grows and how automated pipelines help teams integrate, test, package and deploy software consistently.

I also learned the difference between Continuous Integration, Continuous Delivery and Continuous Deployment.

Most importantly, I understood the basic anatomy of a pipeline:

```text
Trigger → Stage → Job → Step → Runner → Artifact
```

This gives me the foundation required to start building real GitHub Actions pipelines in the next stages of my DevOps journey.

