# Configuring entries in computer UEFI
# amnesic
export KERNEL="linux-lts"
export BOOT_DISK="/dev/sda"
#export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"

efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
    -L "ZFSBootMenu (Backup)" \
    -l "EFI/zbm/vmlinuz-$KERNEL-backup.EFI"
efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
    -L "ZFSBootMenu" \
    -l "EFI/zbm/vmlinuz-$KERNEL.EFI"
swapoff /dev/zvol/zroot/swap
umount -n -R /mnt
zfs umount -a
zpool export zroot
