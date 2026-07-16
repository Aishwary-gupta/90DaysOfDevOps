# 🐚 Shell Scripting Cheat Sheet

A quick reference guide for Bash scripting fundamentals, commonly used commands, scripting patterns, debugging techniques, and text-processing utilities.

---

# Quick Reference Table

| Topic | Syntax | Example |
|--------|--------|---------|
| Variable | `VAR="value"` | `NAME="Aishwary"` |
| Argument | `$1` | `./script.sh hello` |
| If | `if [ ]; then` | `if [ -f file ]; then` |
| For Loop | `for i in list` | `for i in 1 2 3` |
| Function | `name(){}` | `greet(){}` |
| Grep | `grep pattern file` | `grep ERROR log.txt` |
| Awk | `awk '{print $1}' file` | `awk -F: '{print $1}'` |
| Sed | `sed 's/a/b/'` | `sed -i 's/http/https/' file` |

---

# 1. Basics

## Shebang

```bash
#!/bin/bash
```

Defines which interpreter executes the script.

---

## Run Script

```bash
chmod +x script.sh
./script.sh

# OR

bash script.sh
```

---

## Comments

```bash
# Single line comment

echo "Hello"   # Inline comment
```

---

## Variables

```bash
NAME="Aishwary"

echo $NAME
echo "$NAME"
echo '$NAME'
```

Difference

- `" "` expands variables
- `' '` treats everything literally

---

## User Input

```bash
read -p "Enter Name: " NAME

echo "Hello $NAME"
```

---

## Command Line Arguments

```bash
$0   # Script name
$1   # First argument
$2   # Second argument
$#   # Number of arguments
$@   # All arguments
$?   # Exit status
```

Example

```bash
./script.sh DevOps Linux
```

---

# 2. Operators & Conditionals

## String Comparison

```bash
[ "$A" = "$B" ]
[ "$A" != "$B" ]
[ -z "$A" ]
[ -n "$A" ]
```

---

## Integer Comparison

```bash
-eq
-ne
-lt
-gt
-le
-ge
```

Example

```bash
if [ "$NUM" -gt 10 ]
then
    echo "Greater"
fi
```

---

## File Tests

```bash
-f File exists

-d Directory exists

-e Exists

-r Readable

-w Writable

-x Executable

-s Not Empty
```

---

## If Else

```bash
if [ condition ]
then
    command
elif [ condition ]
then
    command
else
    command
fi
```

---

## Logical Operators

```bash
&&

||

!
```

Example

```bash
[ -f file ] && echo Exists
```

---

## Case Statement

```bash
case $OPTION in

start)
echo "Starting"
;;

stop)
echo "Stopping"
;;

*)
echo "Invalid"
;;

esac
```

---

# 3. Loops

## For Loop

```bash
for fruit in Apple Mango Orange
do
    echo $fruit
done
```

---

## C Style Loop

```bash
for ((i=1;i<=5;i++))
do
    echo $i
done
```

---

## While Loop

```bash
COUNT=5

while [ $COUNT -gt 0 ]
do
    echo $COUNT
    COUNT=$((COUNT-1))
done
```

---

## Until Loop

```bash
COUNT=1

until [ $COUNT -gt 5 ]
do
    echo $COUNT
    COUNT=$((COUNT+1))
done
```

---

## break & continue

```bash
break

continue
```

---

## Loop Files

```bash
for file in *.log
do
    echo "$file"
done
```

---

## Read File Line by Line

```bash
while read line
do
    echo "$line"
done < file.txt
```

---

# 4. Functions

## Function

```bash
greet(){

echo "Hello"

}
```

Call

```bash
greet
```

---

## Function Arguments

```bash
greet(){

echo "Hello $1"

}

greet Aishwary
```

---

## Return

```bash
sum(){

echo $(( $1+$2 ))

}
```

---

## Local Variables

```bash
demo(){

local NAME="Linux"

}
```

---

# 5. Text Processing

## grep

```bash
grep ERROR log.txt

grep -i error log.txt

grep -r ERROR .

grep -n ERROR log.txt

grep -c ERROR log.txt

grep -v INFO log.txt

grep -E "ERROR|WARN" log.txt
```

---

## awk

```bash
awk '{print $1}' file

awk -F: '{print $1}' /etc/passwd

awk 'NR>1'

awk 'BEGIN{} END{}'
```

---

## sed

```bash
sed 's/http/https/' file

sed -i 's/foo/bar/g' file

sed '2d' file
```

---

## cut

```bash
cut -d: -f1 /etc/passwd
```

---

## sort

```bash
sort file

sort -n

sort -r

sort -u
```

---

## uniq

```bash
uniq

uniq -c
```

---

## tr

```bash
tr a-z A-Z

tr -d ' '
```

---

## wc

```bash
wc

wc -l

wc -w

wc -c
```

---

## head / tail

```bash
head -5 file

tail -5 file

tail -f logfile.log
```

---

# 6. Useful One-Liners

Delete logs older than 30 days

```bash
find /var/log -name "*.log" -mtime +30 -delete
```

Count log lines

```bash
wc -l *.log
```

Replace text in multiple files

```bash
find . -name "*.conf" -exec sed -i 's/http/https/g' {} \;
```

Check if nginx is running

```bash
systemctl is-active nginx
```

Monitor disk usage

```bash
df -h
```

Tail logs for errors

```bash
tail -f /var/log/syslog | grep ERROR
```

---

# 7. Error Handling & Debugging

## Exit Status

```bash
echo $?

exit 0

exit 1
```

---

## set -e

Stop immediately if a command fails.

```bash
set -e
```

---

## set -u

Treat unset variables as errors.

```bash
set -u
```

---

## set -o pipefail

Fail if any command in a pipeline fails.

```bash
set -o pipefail
```

---

## Debug Mode

```bash
set -x
```

Shows every command before execution.

---

## Trap

```bash
cleanup(){

echo "Cleaning..."

}

trap cleanup EXIT
```

---

# Common DevOps Commands

```bash
hostname

hostname -I

uptime

free -h

df -h

lsblk

top

ps aux

systemctl status nginx

journalctl -u nginx

ss -tulpn

ip addr

ping google.com

curl -I google.com

dig google.com
```

---

# Best Practices

- Always use `#!/bin/bash`
- Use meaningful variable names.
- Quote variables using `"$VAR"`
- Use functions for reusable code.
- Enable strict mode:

```bash
set -euo pipefail
```

- Check exit codes.
- Validate input before execution.
- Comment complex logic.
- Keep scripts modular.
- Test before running in production.

---

# Summary

This cheat sheet covers:

- Bash Basics
- Variables
- User Input
- Arguments
- Conditions
- Loops
- Functions
- Text Processing
- Error Handling
- Useful DevOps One-Liners

It serves as a quick reference while writing and debugging Bash scripts in real-world DevOps workflows.
