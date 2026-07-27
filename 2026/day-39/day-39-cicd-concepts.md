# Day 39 – What is CI/CD?

## Overview

This project is part of my **90 Days of DevOps** journey.

Today I learned the fundamentals of Continuous Integration and Continuous Delivery/Deployment (CI/CD). Before building pipelines, I focused on understanding why CI/CD exists, how modern software teams use it, and the building blocks of a CI/CD pipeline.

---

# Topics Covered

- Problems with manual deployments
- Continuous Integration (CI)
- Continuous Delivery
- Continuous Deployment
- CI/CD Pipeline Architecture
- Pipeline Triggers
- Stages
- Jobs
- Steps
- Runners
- Artifacts
- GitHub Actions Overview
- Real-world CI/CD Workflow

---

# Problem Statement

Without CI/CD:

- Manual deployments are slow and error-prone.
- Developers may overwrite each other's work.
- Bugs reach production more easily.
- "It works on my machine" becomes a common issue due to environment differences.
- Frequent deployments become difficult.

---

# Continuous Integration (CI)

Continuous Integration is the practice of automatically building and testing code whenever developers push changes to a shared repository.

Benefits:

- Detects bugs early
- Prevents broken code from reaching the main branch
- Encourages small, frequent commits
- Improves collaboration

---

# Continuous Delivery

Continuous Delivery extends CI by automatically preparing applications for deployment.

Deployment to production still requires manual approval.

Benefits:

- Faster releases
- Reduced deployment risks
- Production-ready software at any time

---

# Continuous Deployment

Continuous Deployment goes one step further by automatically deploying every successful change to production without manual intervention.

Benefits:

- Fully automated releases
- Faster customer feedback
- Continuous product improvement

---

# CI vs Continuous Delivery vs Continuous Deployment

| Feature | CI | Continuous Delivery | Continuous Deployment |
|----------|----|--------------------|-----------------------|
| Build | Yes | Yes | Yes |
| Testing | Yes | Yes | Yes |
| Deploy to Staging | Optional | Yes | Yes |
| Manual Approval | No | Yes | No |
| Automatic Production Deployment | No | No | Yes |

---

# Pipeline Components

## Trigger

Starts the pipeline.

Examples:

- Git Push
- Pull Request
- Scheduled Job
- Manual Trigger

---

## Stage

Logical phase of a pipeline.

Examples:

- Build
- Test
- Deploy

---

## Job

A group of related tasks within a stage.

Example:

Build Stage

- Install Dependencies
- Compile Code
- Build Docker Image

---

## Step

A single command executed inside a job.

Example:

```bash
npm install
npm run test
docker build -t app:v1 .
