# Day 17 – Shell Scripting: Loops, Arguments & Error Handling

## Objective

Today I learned how to write more dynamic and reliable Bash scripts using loops, command-line arguments, package automation, and error handling. These are essential concepts for automating Linux administration and DevOps workflows.

---

## Scripts Created

- `for_loop.sh`
- `count.sh`
- `countdown.sh`
- `greet.sh`
- `args_demo.sh`
- `install_packages.sh`
- `safe_script.sh`

---

## Concepts Learned

- `for` loops
- `while` loops
- Command-line arguments (`$0`, `$1`, `$#`, `$@`)
- Installing packages through scripts
- Checking for root privileges using `$EUID`
- Error handling with `set -e`, `&&`, and `||`
- Debugging scripts with `bash -x`

---

## Commands Used

```bash
chmod +x
bash -x
dpkg -s
apt update
apt install
mkdir
touch
echo
read
```

---

## Key Learnings

- Loops reduce repetitive manual work.
- Command-line arguments make scripts reusable.
- Checking exit codes and handling errors improves script reliability.
- Root privilege checks prevent permission-related failures.
- Bash scripting is a core skill for DevOps automation.

---

## Outcome

By the end of Day 17, I can create Bash scripts that automate repetitive tasks, process command-line arguments, install required packages, and handle errors more safely using standard Bash practices.
