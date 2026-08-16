# Day 47 – Advanced Triggers in GitHub Actions

## Overview

Today I explored **advanced GitHub Actions triggers** and learned how workflows can respond to different events instead of running only on every push.

The focus was on building **event-driven, automated CI/CD workflows** using Pull Request events, cron schedules, path filters, workflow chaining, and external triggers.

## What I Learned

* Pull Request lifecycle events: `opened`, `synchronize`, `reopened`, and `closed`
* Conditional execution for merged Pull Requests
* PR validation using branch names and file-size checks
* Scheduled workflows using **cron**
* Manual execution using `workflow_dispatch`
* Path and branch filters
* Chaining workflows with `workflow_run`
* Triggering workflows externally with `repository_dispatch`
* Using GitHub event context such as:

  * `github.event.action`
  * `github.event.pull_request.title`
  * `github.event.pull_request.user.login`
  * `github.head_ref`
  * `github.event.schedule`
  * `github.event.workflow_run.conclusion`
  * `github.event.client_payload`

## Workflows Created

### 1. PR Lifecycle

**File:** `.github/workflows/pr-lifecycle.yml`

Runs when a Pull Request is:

* Opened
* Updated
* Reopened
* Closed

It displays the PR event, title, author, source branch, and target branch.

It also contains a condition that runs only when the Pull Request is actually merged.

### 2. PR Checks

**File:** `.github/workflows/pr-checks.yml`

Created a basic PR gate with three checks:

* **File Size Check** – fails when a file is larger than 1 MB
* **Branch Name Check** – allows `feature/*`, `fix/*`, and `docs/*`
* **PR Body Check** – warns when the PR description is empty

### 3. Scheduled Tasks

**File:** `.github/workflows/scheduled-tasks.yml`

Added scheduled workflows using cron:

```yaml
'30 2 * * 1'
'0 */6 * * *'
```

The workflow also supports `workflow_dispatch` so it can be tested manually.

A health-check step uses `curl` to verify a URL response.

### 4. Smart Triggers

**File:** `.github/workflows/smart-triggers.yml`

Configured workflows to run only when relevant files change.

Example:

```yaml
paths:
  - 'src/**'
  - 'app/**'
```

Also explored `paths-ignore` for ignoring documentation-only changes.

Branch filters were added for:

```yaml
main
release/*
```

### 5. Workflow Chaining

Created:

```text
.github/workflows/tests.yml
.github/workflows/deploy-after-tests.yml
```

`tests.yml` runs the tests first.

`deploy-after-tests.yml` listens for the completion of the test workflow using `workflow_run`.

Deployment proceeds only when:

```yaml
github.event.workflow_run.conclusion == 'success'
```

This demonstrates a simple **Test → Deploy** pipeline.

### 6. External Trigger

**File:** `.github/workflows/external-trigger.yml`

Configured `repository_dispatch` to respond to:

```text
deploy-request
```

The workflow reads data from the external event payload:

```yaml
github.event.client_payload.environment
```

This can allow external systems such as monitoring tools, bots, or internal platforms to trigger GitHub Actions.

## Cron Notes

### Every Weekday at 9 AM IST

IST is UTC+5:30, so 9:00 AM IST = 3:30 AM UTC.

```text
30 3 * * 1-5
```

### First Day of Every Month at Midnight

```text
0 0 1 * *
```

### Why Scheduled Workflows Can Be Delayed

GitHub notes that scheduled workflows can experience delays during periods of high load. Scheduled workflows may also be automatically disabled in repositories with prolonged inactivity.

## `paths` vs `paths-ignore`

Use `paths` when a workflow should run **only when specific files or directories change**.

Use `paths-ignore` when a workflow should run normally **except when only certain files change**.

For example:

```yaml
paths:
  - 'src/**'
```

is useful when only source-code changes should trigger a workflow.

```yaml
paths-ignore:
  - '*.md'
  - 'docs/**'
```

is useful when documentation-only changes should not trigger it.

## `workflow_run` vs `workflow_call`

### `workflow_run`

`workflow_run` is useful for **chaining independent workflows**.

Example:

```text
Tests → Deploy
```

One workflow finishes, and another workflow starts based on its result.

### `workflow_call`

`workflow_call` is used to create **reusable workflows**.

Example:

```text
Application A ─┐
Application B ─┼──> Reusable CI Workflow
Application C ─┘
```

So, in simple terms:

> **`workflow_run`**** connects workflows based on events, while ****`workflow_call`**** lets workflows reuse another workflow like a function.**

## Key Takeaway

The biggest lesson from Day 47 was that GitHub Actions is not just about running commands after a `git push`.

By combining **events, conditions, schedules, filters, workflow chaining, and external triggers**, we can build more intelligent and event-driven CI/CD pipelines.

## Verification

* [ ] PR lifecycle workflow tested
* [ ] PR validation tested with a Pull Request
* [ ] Scheduled workflow added
* [ ] Manual `workflow_dispatch` tested
* [ ] Path and branch filters tested
* [ ] Test → Deploy workflow chain verified
* [ ] `repository_dispatch` tested
* [ ] PR checks screenshot added

## Repository Structure

```text
2026/
└── day-47/
    ├── day-47-advanced-triggers.md
    └── .github/
        └── workflows/
            ├── pr-lifecycle.yml
            ├── pr-checks.yml
            ├── scheduled-tasks.yml
            ├── smart-triggers.yml
            ├── tests.yml
            ├── deploy-after-tests.yml
            └── external-trigger.yml
```

#90DaysOfDevOps #GitHubActions #DevOps

