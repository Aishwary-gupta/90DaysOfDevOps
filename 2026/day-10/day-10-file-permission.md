# Day 10 – File Permissions & File Operations Challenge

## Objective

Practice creating, reading, and managing files while understanding Linux file permissions using symbolic and numeric modes.

---

## Files Created

* `devops.txt`
* `notes.txt`
* `script.sh`
* `project/` (directory)

---

## Permission Changes

| Item         | Before       | After              | Purpose                        |
| ------------ | ------------ | ------------------ | ------------------------------ |
| `script.sh`  | `-rw-r--r--` | `-rwxr-xr-x`       | Made executable                |
| `devops.txt` | `-rw-r--r--` | `-r--r--r--`       | Read-only                      |
| `notes.txt`  | Default      | `-rw-r-----` (640) | Owner read/write, group read   |
| `project/`   | Default      | `drwxr-xr-x` (755) | Standard directory permissions |

---

## Commands Used

```bash
touch devops.txt

echo "Linux permissions are important." > notes.txt
echo "DevOps engineers use chmod daily." >> notes.txt

vim script.sh

ls -l

cat notes.txt

vim -R script.sh

head -n 5 /etc/passwd

tail -n 5 /etc/passwd

chmod +x script.sh
./script.sh

chmod a-w devops.txt

chmod 640 notes.txt

mkdir project
chmod 755 project

ls -ld project
```

---

## Permission Tests

* Attempted to write to a read-only file and observed a permission error.
* Removed execute permission from `script.sh` and confirmed it could not be executed.
* Restored execute permission and successfully ran the script.

---

## What I Learned

* Linux permissions control access for the owner, group, and others.
* Symbolic (`chmod +x`) and numeric (`chmod 755`) permission modes achieve the same goal in different ways.
* Executable scripts require the execute (`x`) permission.
* Correct permissions improve both security and collaboration.
* Understanding file permissions is essential for managing scripts, SSH keys, configuration files, and applications in production.

---

## Screenshots Included

* File creation and default permissions
* Permission changes using `chmod`
* Script execution
* Permission error demonstrations

