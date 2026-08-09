# Day 42 – GitHub Actions Runners

## Overview

This project is part of my **90 Days of DevOps** journey.

On Day 42, I learned how GitHub Actions jobs are executed using runners. I explored GitHub-hosted runners running on different operating systems and configured a self-hosted runner to execute CI/CD jobs on my own machine.

---

## Objectives

- Understand GitHub Actions runners
- Explore GitHub-hosted runners
- Run workflows on Ubuntu, Windows, and macOS
- Inspect pre-installed tools
- Configure a self-hosted runner
- Execute a workflow on my own machine
- Understand runner labels
- Compare GitHub-hosted and self-hosted runners

---

# What is a Runner?

A runner is the machine that executes a GitHub Actions job.

For example:

```yaml
runs-on: ubuntu-latest
```

tells GitHub Actions to execute the job on a GitHub-hosted Ubuntu runner.

The basic workflow is:

```text
Developer
    |
    | git push
    v
GitHub Repository
    |
    v
GitHub Actions
    |
    v
Runner
    |
    +---- Checkout code
    +---- Run tests
    +---- Build application
    +---- Deploy
```

---

# Task 1 – GitHub-Hosted Runners

I created a workflow containing three jobs:

- Ubuntu
- Windows
- macOS

Each job displayed:

- Operating system
- Hostname
- Current user

Example:

```yaml
jobs:
  ubuntu:
    runs-on: ubuntu-latest

  windows:
    runs-on: windows-latest

  macos:
    runs-on: macos-latest
```

## Observation

The three jobs were executed independently and could run in parallel.

---

# What is a GitHub-Hosted Runner?

A GitHub-hosted runner is a virtual machine managed by GitHub that executes GitHub Actions workflows.

GitHub manages:

- Machine provisioning
- Operating system
- Runner software
- Base environment
- Machine lifecycle

This makes GitHub-hosted runners easy to use for standard CI/CD workflows.

---

# Task 2 – Pre-Installed Software

I checked the following tools on the Ubuntu runner:

```bash
docker --version
python --version
node --version
git --version
```

## Why Pre-Installed Software Matters

Pre-installed tools reduce pipeline setup time.

Instead of installing every tool before every job, commonly used development tools are already available on the runner.

This makes CI/CD workflows faster and easier to maintain.

---

# Task 3 – Self-Hosted Runner

I configured a self-hosted GitHub Actions runner.

The setup process was:

```text
GitHub Repository
       |
       v
Settings
       |
       v
Actions
       |
       v
Runners
       |
       v
New self-hosted runner
       |
       v
Configure machine
       |
       v
Runner becomes Idle
```

The self-hosted runner was registered with my GitHub repository.

---

# Self-Hosted Runner

A self-hosted runner is a machine managed by me or my organization that runs GitHub Actions jobs.

It can be:

- Personal computer
- Cloud VM
- Company server
- On-premise server

Unlike GitHub-hosted runners, I am responsible for maintaining the machine.

---

# Task 4 – Running a Job on My Runner

I created:

```text
.github/workflows/self-hosted.yml
```

The workflow uses:

```yaml
runs-on: self-hosted
```

Example:

```yaml
name: Self Hosted Runner

on:
  push:

jobs:
  test-runner:
    runs-on: self-hosted

    steps:
      - name: Show hostname
        run: hostname

      - name: Show working directory
        run: pwd

      - name: Create test file
        run: echo "Created by GitHub Actions" > devops-runner-test.txt

      - name: Verify file
        run: cat devops-runner-test.txt
```

## Result

The workflow executed on my self-hosted machine.

The test file was created by the GitHub Actions job on the machine running the self-hosted runner.

---

# Task 5 – Runner Labels

Labels allow GitHub Actions to select a specific runner.

Example:

```yaml
runs-on: [self-hosted, linux, my-linux-runner]
```

The workflow will only run on a self-hosted runner containing the required labels.

## Why Labels Matter

Organizations may have many runners.

For example:

```text
runner-1 → Linux
runner-2 → Windows
runner-3 → GPU
runner-4 → High CPU
```

Labels allow workflows to target the correct infrastructure.

---

# Task 6 – GitHub-Hosted vs Self-Hosted

| Feature | GitHub-Hosted | Self-Hosted |
|---|---|---|
| Infrastructure | Managed by GitHub | Managed by user/organization |
| Setup | Easy | Requires configuration |
| Maintenance | GitHub | User/organization |
| Pre-installed tools | Many tools available | User installs required tools |
| Customization | Limited | High |
| Hardware | Standard environments | Custom hardware possible |
| Cost | GitHub Actions usage/plan allowances | Infrastructure cost |
| Security responsibility | Shared responsibility | Greater responsibility for organization |
| Best for | Standard CI/CD | Custom/private workloads |

---

# GitHub-Hosted Runner Workflow

```text
GitHub
   |
   v
GitHub Actions
   |
   v
GitHub-Hosted Runner
   |
   +---- Build
   +---- Test
   +---- Deploy
```

---

# Self-Hosted Runner Workflow

```text
GitHub
   |
   v
GitHub Actions
   |
   v
Self-Hosted Runner
   |
   v
My Machine / Cloud VM
   |
   +---- Build
   +---- Test
   +---- Deploy
```

---

# Key Learnings

1. A runner is the machine that executes a GitHub Actions job.
2. GitHub-hosted runners are managed by GitHub.
3. Self-hosted runners are managed by the user or organization.
4. Self-hosted runners provide greater control and customization.
5. Runner labels allow workflows to target specific infrastructure.
6. Self-hosted runners require additional security and maintenance.
7. Different operating system runners can be used to test applications across platforms.

---

# Real-World Use Cases

| Runner Type | Example |
|---|---|
| GitHub-Hosted | Standard application testing |
| Self-Hosted | Private company applications |
| Self-Hosted GPU | Machine learning workloads |
| Self-Hosted High CPU | Large builds |
| Self-Hosted Internal Network | Applications requiring private infrastructure |
| Multiple Runners | Large CI/CD environments |

---

# Security Considerations

Self-hosted runners require careful security management.

Important considerations include:

- Restricting repository access
- Protecting secrets
- Keeping the operating system updated
- Installing security patches
- Isolating runners from sensitive infrastructure
- Avoiding untrusted code execution
- Monitoring runner activity

Self-hosted runners should not be treated as disposable GitHub-hosted environments.

---

---

# Outcome

Successfully explored GitHub-hosted runners across multiple operating systems and configured a self-hosted runner to execute GitHub Actions workflows on my own infrastructure.

This gave me a better understanding of how CI/CD jobs are actually executed and how organizations can choose between managed and self-managed runner infrastructure.

---

## Author

**Aishwary Gupta**

**90 Days of DevOps Challenge**
