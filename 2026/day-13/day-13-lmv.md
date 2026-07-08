# Day 13 – Linux Logical Volume Manager (LVM)

## Objective

Learn the fundamentals of Linux Logical Volume Manager (LVM) by creating a Physical Volume, Volume Group, and Logical Volume, then formatting, mounting, and extending the storage.

---

## Commands Used

```bash
sudo -i

lsblk
pvs
vgs
lvs
df -h

dd if=/dev/zero of=/tmp/disk1.img bs=1M count=1024
losetup -fP /tmp/disk1.img
losetup -a

sudo apt update
sudo apt install lvm2 -y

pvcreate /dev/loop0
pvs

vgcreate devops-vg /dev/loop0
vgs

lvcreate -L 500M -n app-data devops-vg
lvs

mkfs.ext4 /dev/devops-vg/app-data

mkdir -p /mnt/app-data
mount /dev/devops-vg/app-data /mnt/app-data

df -h /mnt/app-data

touch /mnt/app-data/test.txt
ls -l /mnt/app-data

lvextend -L +200M /dev/devops-vg/app-data
resize2fs /dev/devops-vg/app-data

df -h /mnt/app-data
```

---

## LVM Workflow

1. Created a virtual disk using a loop device.
2. Initialized the disk as a Physical Volume (PV).
3. Created a Volume Group (VG).
4. Created a Logical Volume (LV).
5. Formatted the Logical Volume with the ext4 filesystem.
6. Mounted the volume to `/mnt/app-data`.
7. Extended the Logical Volume and resized the filesystem.

---

## What I Learned

* LVM provides flexible storage management by separating physical disks from logical storage.
* A Physical Volume is combined into a Volume Group, from which Logical Volumes are created.
* Extending storage with `lvextend` must be followed by filesystem resizing using `resize2fs`.
* LVM is commonly used in production systems because it allows storage expansion with minimal downtime.
* Commands like `lsblk`, `pvs`, `vgs`, and `lvs` help inspect and manage storage resources.

---

## Screenshots Included

* Initial storage layout (`lsblk`, `df -h`)
* Physical Volume creation
* Volume Group creation
* Logical Volume creation
* Mounted filesystem
* Extended Logical Volume

