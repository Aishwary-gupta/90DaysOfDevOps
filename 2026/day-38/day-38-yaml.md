# Day 38 – YAML Basics

## Overview

This project is part of my **90 Days of DevOps** journey.

Today I learned the fundamentals of YAML, the configuration language used by most DevOps tools such as Docker Compose, Kubernetes, GitHub Actions, Ansible, Azure DevOps, and GitLab CI.

The focus was on understanding YAML syntax, indentation rules, lists, nested objects, multiline strings, and validation.

---

## Topics Covered

- What is YAML
- YAML Syntax
- Key-Value Pairs
- Lists
- Inline Lists
- Nested Objects
- Multi-line Strings
- YAML Validation
- Indentation Rules
- Booleans
- YAML Best Practices

---

## Project Structure

```text
day-38/
│
├── person.yaml
├── server.yaml
└── day-38-yaml.md
```

---

## Files Created

### person.yaml

Contains personal information using:

- Key-value pairs
- Lists
- Inline lists
- Boolean values

---

### server.yaml

Contains:

- Server configuration
- Database configuration
- Nested objects
- Credentials
- Multi-line startup scripts

---

## YAML Concepts Learned

### Key-Value Pair

```yaml
name: Aishwary
role: DevOps Engineer
```

---

### Lists

```yaml
tools:
  - Docker
  - Git
  - Linux
  - AWS
```

Inline list:

```yaml
hobbies: [Gym, Reading]
```

---

### Nested Objects

```yaml
server:
  name: web01
  ip: 192.168.1.10
  port: 80
```

---

### Multi-Line Strings

Preserve formatting:

```yaml
startup_script: |
  apt update
  apt install nginx
```

Fold lines:

```yaml
description: >
  This text
  becomes one line.
```

---

## YAML Validation

Validated files using:

```bash
yamllint person.yaml
yamllint server.yaml
```

---

## Key Learnings

- YAML is a human-readable configuration language widely used in DevOps.
- YAML relies entirely on spaces and indentation for structure.
- Proper validation helps prevent configuration errors in production.

---

## Outcome

Successfully created valid YAML files and learned how YAML structures configuration for modern DevOps tools.

---

## Skills Gained

- YAML Syntax
- Configuration Management
- YAML Validation
- Docker Compose Fundamentals
- Kubernetes Configuration Basics
- DevOps Foundations

---

## Repository

This project is part of my **90 Days of DevOps** challenge where I practice DevOps concepts through hands-on labs and real-world projects every day.

---

## Author

**Aishwary Gupta**

90 Days of DevOps Challenge
