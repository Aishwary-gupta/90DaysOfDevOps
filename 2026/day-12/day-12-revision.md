# Day 12 – Revision (Days 01–11)

## Goal

Review Linux fundamentals learned during the first eleven days and reinforce key concepts through quick hands-on practice.

---

## Progress Review

* Completed Linux fundamentals and command-line practice.
* Built consistency by documenting each day's work on GitHub.
* Shared progress regularly on LinkedIn.
* Ready to move on to Linux automation and shell scripting.

---

## Process & Service Review

### Commands Practiced

```bash
ps aux | head
systemctl status ssh
journalctl -u ssh -n 20
```

### Observations

* Verified running processes.
* Confirmed the selected service was active.
* Reviewed recent service logs and found no critical errors.

---

## File Operations Practice

### Commands Practiced

```bash
touch notes.txt
echo "Linux Revision Day 12" > notes.txt
echo "Practicing permissions." >> notes.txt
cat notes.txt
cp notes.txt notes-backup.txt
chmod 640 notes.txt
sudo chown tokyo notes.txt
ls -l
```

### Observations

* Successfully created, copied, and modified files.
* Verified permission and ownership changes using `ls -l`.

---

## Top 5 Linux Commands

* `top`
* `ps aux`
* `journalctl -u <service>`
* `df -h`
* `ss -tulpn`

---

## User & Group Practice

Created a temporary user, verified it using `id`, and removed it after testing.

---

## Self-Check

### 1. Three commands that save me the most time

* `top`
* `journalctl -u <service>`
* `ls -l`

### 2. Commands to check service health

```bash
systemctl status <service>
journalctl -u <service> -n 20
ps aux | grep <service>
```

### 3. Safe ownership and permission change

```bash
sudo chown tokyo:developers app.log
chmod 640 app.log
```

### 4. Focus for the next three days

* Shell scripting
* Linux package management
* Automation using Bash

---

## Key Takeaways

* Confidence with Linux commands has improved through daily practice.
* Understanding permissions and ownership is essential for secure system administration.
* A structured troubleshooting workflow helps diagnose issues efficiently.
* Consistency is more valuable than learning many new topics at once.

