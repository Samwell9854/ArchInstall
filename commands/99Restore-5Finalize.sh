export BOOT_DISK="/dev/sda"
#export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}${BOOT_PART}"
#export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"

efibootmgr -c -d "$BOOT_DISK" -p "$BOOT_PART" \
    -L "ZFSBootMenu" \
    -l 'EFI/zbm/vmlinuz-linux.EFI'
swapoff /dev/zvol/zroot/swap
umount -n -R /mnt
zfs umount -a
zpool export zroot