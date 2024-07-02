#!/bin/sh
# DO NOT RUN THIS SCRIPT LIVE - some arguments on the recv side are.... scary
CurrentSnapshotName=none
NewSnapshotName=2024-01-24-zbackup
zfs snapshot zroot/ROOT@$NewSnapshotName
zfs snapshot -r zroot/data@$NewSnapshotName
zfs snapshot -r virt@$NewSnapshotName

# First run
zfs send -R zroot/ROOT@$NewSnapshotName | zfs recv -uvx encryption zbackup/zroot/ROOT
zfs send -R zroot/data@$NewSnapshotName | zfs recv -uvx encryption zbackup/zroot/data
zfs send -R virt@$NewSnapshotName | zfs recv -uvx encryption zbackup/virt

# Consecutive runs (missing -x encryption - missing -I first_snap second_snap)
zfs send -Ri @$CurrentSnapshotName zroot/ROOT@$NewSnapshotName | zfs recv -uvx encryption zbackup/zroot/ROOT
zfs send -Ri @$CurrentSnapshotName zroot/data@$NewSnapshotName | zfs recv -uvx encryption zbackup/zroot/data
zfs send -Ri @$CurrentSnapshotName virt@$NewSnapshotName | zfs recv -uvx encryption zbackup/virt
