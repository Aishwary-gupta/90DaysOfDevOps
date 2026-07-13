# Day 18 – Shell Scripting: Functions & Intermediate Concepts

## Objective

Today I learned how to write cleaner and more reliable Bash scripts using functions, local variables, strict mode, and modular script design. These concepts make automation scripts easier to maintain and are widely used in production DevOps environments.

---

## Scripts Created

- `functions.sh`
- `disk_check.sh`
- `strict_demo.sh`
- `local_demo.sh`
- `system_info.sh`

---

## Concepts Learned

- Creating and calling Bash functions
- Passing arguments to functions
- Using local variables
- Strict mode with `set -euo pipefail`
- Organizing scripts using a `main()` function
- Building reusable system health check scripts

---

## Commands Used

```bash
hostname
uptime
df -h
free -h
ps
grep
head
set
local
```

---

## What `set -euo pipefail` Means

- `set -e` → Exit immediately if any command fails.
- `set -u` → Exit when an undefined variable is used.
- `set -o pipefail` → Return failure if any command in a pipeline fails.

Using these options helps create safer and more predictable Bash scripts.

---

## Key Learnings

- Functions reduce code duplication and improve readability.
- Local variables prevent accidental changes to global variables.
- Strict mode helps detect errors early and makes scripts more reliable.
- Organizing code into functions and a `main()` function is a common DevOps scripting practice.
- Modular scripts are easier to debug and maintain.

---

## Outcome

By the end of Day 18, I can write modular Bash scripts using functions, implement strict error handling with `set -euo pipefail`, use local variables safely, and build a reusable system information reporting script.
