ssh user@host "zfs send -c zbackup/host/zroot/ROOT/arch@snapshot" | pv | zfs receive -Fu zroot/ROOT/arch
ssh user@host "zfs send -cR zbackup/host/zroot/data@snapshot" | pv | zfs receive -Fu zroot/data
