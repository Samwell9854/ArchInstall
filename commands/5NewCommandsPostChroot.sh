efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
    -L "ZFSBootMenu (Backup)" \
    -l '\EFI\ZBM\vmlinuz-backup.efi'
efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
    -L "ZFSBootMenu" \
    -l '\EFI\ZBM\vmlinuz.efi'
swapoff /dev/zvol/zroot/swap
umount -n -R /mnt
zfs umount -a
zpool export zroot
