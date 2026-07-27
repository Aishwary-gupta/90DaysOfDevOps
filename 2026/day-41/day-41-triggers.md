# Day 41 – Triggers & Matrix Builds

## Overview

This project is part of my **90 Days of DevOps** journey.

On Day 41, I learned how GitHub Actions workflows can be triggered by different events and how to execute the same workflow across multiple environments using Matrix Builds. These concepts are fundamental to building scalable and efficient CI/CD pipelines.

---

## Objectives

- Learn different GitHub Actions triggers
- Create workflows for Pull Requests
- Schedule workflows using Cron
- Trigger workflows manually
- Use workflow inputs
- Execute parallel jobs with Matrix Builds
- Understand matrix exclusions and fail-fast behavior

---

## Project Structure

```text
day-41/
├── .github/
│   └── workflows/
│       ├── hello.yml
│       ├── pr-check.yml
│       ├── manual.yml
│       └── matrix.yml
└── day-41-triggers.md
```

---

# Task 1 – Pull Request Trigger

## Objective

Run a workflow whenever a Pull Request is opened or updated against the `main` branch.

### Workflow Features

- Trigger only on Pull Requests
- Print the branch name
- Validate code before merge

### Sample Trigger

```yaml
on:
  pull_request:
    branches:
      - main
```

### Learning

Pull Request workflows help teams prevent broken code from being merged into the main branch by automatically running validation checks.

---

# Task 2 – Scheduled Workflow

## Objective

Automatically run workflows at specific times using Cron syntax.

### Example

```yaml
on:
  schedule:
    - cron: "0 0 * * *"
```

Runs every day at **12:00 AM UTC**.

### Common Uses

- Database backups
- Security scans
- Dependency updates
- Cleanup scripts
- Health monitoring

### Cron Expression

Every Monday at **9:00 AM UTC**

```text
0 9 * * 1
```

---

# Task 3 – Manual Workflow

## Objective

Trigger workflows manually from the GitHub Actions page.

### Trigger

```yaml
on:
  workflow_dispatch:
```

### Input Example

```yaml
inputs:
  environment:
    description: Deployment Environment
    required: true
```

Possible values:

- staging
- production

### Learning

Manual workflows are commonly used for production deployments and emergency operations where human approval is required.

---

# Task 4 – Matrix Builds

## Objective

Run the same workflow across multiple environments simultaneously.

### Matrix Configuration

Python Versions

- Python 3.10
- Python 3.11
- Python 3.12

Operating Systems

- Ubuntu
- Windows

Total Jobs

```text
3 Python Versions × 2 Operating Systems = 6 Jobs
```

GitHub automatically creates six independent jobs and executes them in parallel.

### Benefits

- Faster testing
- Cross-platform compatibility
- Reduced CI execution time
- Better software reliability

---

# Task 5 – Matrix Exclude

Exclude unsupported combinations from execution.

Example

```yaml
exclude:
  - os: windows-latest
    python-version: "3.10"
```

### Learning

Matrix exclusion helps avoid unnecessary jobs that are unsupported or known to fail.

---

# Task 6 – Fail Fast

Default Behavior

```yaml
fail-fast: true
```

If one matrix job fails, GitHub cancels all remaining jobs.

Using

```yaml
fail-fast: false
```

allows every job to continue running even if one job fails.

### Why Use It?

Useful when you want complete testing results across all environments instead of stopping after the first failure.

---

# GitHub Actions Concepts Learned

| Feature | Description |
|----------|-------------|
| Pull Request Trigger | Runs workflows when a PR is opened or updated |
| Schedule Trigger | Executes workflows automatically using Cron |
| Manual Trigger | Runs workflows manually from GitHub |
| Workflow Inputs | Accepts user input during manual execution |
| Matrix Strategy | Executes multiple job combinations automatically |
| Matrix Exclude | Skips unwanted job combinations |
| Fail Fast | Controls whether remaining jobs stop after a failure |

---

# Commands and Features Practiced

- Pull Request workflow
- Scheduled workflow
- Manual workflow
- Workflow inputs
- Matrix builds
- Parallel execution
- Matrix exclusions
- Fail Fast configuration

---

# Key Learnings

- GitHub Actions supports multiple workflow triggers.
- Pull Request workflows improve code quality before merging.
- Scheduled workflows automate repetitive tasks.
- Manual workflows are useful for production deployments.
- Matrix builds allow testing across multiple operating systems and software versions.
- Parallel execution significantly reduces pipeline execution time.
- `fail-fast` controls whether matrix jobs stop immediately after a failure.

---

# Real-World Use Cases

| Feature | Example |
|----------|---------|
| Pull Request | Run tests before merging code |
| Schedule | Nightly backups and security scans |
| Manual Trigger | Deploy applications to production |
| Matrix Build | Test applications on Ubuntu and Windows |
| Workflow Inputs | Select deployment environment |
| Fail Fast | Stop unnecessary jobs after critical failures |

---

# Outcome

Successfully created multiple GitHub Actions workflows using different trigger types and implemented Matrix Builds to run jobs across multiple Python versions and operating systems. This provided practical experience with scalable CI/CD automation techniques used in real-world DevOps environments.

---

# Screenshots

Add the following screenshots:

- Pull Request workflow execution
- Scheduled workflow
- Manual workflow execution
- Matrix build running multiple jobs
- Successful workflow completion

---

# Conclusion

Day 41 introduced advanced GitHub Actions capabilities beyond basic workflows. Learning different trigger types and Matrix Builds makes CI/CD pipelines more flexible, scalable, and production-ready. These concepts are widely used in enterprise DevOps environments to automate testing, validation, and deployment processes efficiently.

---

## Author

**Aishwary Gupta**

**90 Days of DevOps Challenge**
