# Day 40 – My First GitHub Actions Workflow

## Overview

This project is part of my **90 Days of DevOps** journey.

Today I created my first GitHub Actions workflow and experienced Continuous Integration (CI) in action. Every push to my GitHub repository automatically triggered a workflow running on a GitHub-hosted Ubuntu runner.

---

# Topics Covered

- Introduction to GitHub Actions
- Workflow Structure
- GitHub Hosted Runners
- Workflow Triggers
- Jobs
- Steps
- GitHub Actions Marketplace
- Built-in GitHub Variables
- Pipeline Debugging

---

# Project Structure

```text
github-actions-practice/
│
├── README.md
│
└── .github
    └── workflows
        └── hello.yml
```

---

# Workflow File

```yaml
name: My First GitHub Actions Workflow

on:
  push:

jobs:
  greet:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v4

      - name: Print Hello
        run: echo "Hello from GitHub Actions!"

      - name: Current Date
        run: date

      - name: Branch Name
        run: echo "Branch: ${{ github.ref_name }}"

      - name: Repository Files
        run: ls -la

      - name: Runner Operating System
        run: echo "Runner OS: ${{ runner.os }}"
```

---

# Workflow Anatomy

| Key | Description |
|------|-------------|
| `name` | Gives the workflow a readable name. |
| `on` | Defines when the workflow should start. |
| `jobs` | Collection of tasks executed by the workflow. |
| `runs-on` | Specifies the operating system of the GitHub runner. |
| `steps` | Individual actions or commands executed inside a job. |
| `uses` | Reuses an existing GitHub Action from the marketplace. |
| `run` | Executes shell commands on the runner. |

---

# Pipeline Flow

Developer Pushes Code

↓

GitHub Detects Push

↓

Ubuntu Runner Starts

↓

Repository Checkout

↓

Execute Commands

↓

Pipeline Result

↓

Runner Destroyed

---

# Built-in GitHub Variables

- `${{ github.ref_name }}` → Current branch name
- `${{ github.repository }}` → Repository name
- `${{ github.actor }}` → User who triggered the workflow
- `${{ runner.os }}` → Runner operating system

---

# What I Learned

- GitHub Actions automatically runs workflows after code changes.
- Every workflow runs on a fresh virtual machine.
- Workflows are written using YAML.
- Pipelines consist of workflows, jobs, and steps.
- Built-in variables provide repository and runner information.
- Failed steps stop the workflow immediately.

---

# Outcome

Successfully created my first GitHub Actions workflow, executed it on GitHub-hosted runners, observed successful and failed pipeline executions, and understood the basic workflow structure.

---

# Author

**Aishwary Gupta**

90 Days of DevOps Challenge
