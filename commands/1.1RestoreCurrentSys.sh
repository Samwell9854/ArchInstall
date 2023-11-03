source /etc/os-release
export ID
export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"
export POOL_DISK="/dev/nvme0n1"
export POOL_PART="2"
export POOL_DEVICE="${POOL_DISK}p${POOL_PART}"

zpool import -N -R /mnt zroot
zfs mount zroot/ROOT/${ID}
zfs mount -a
mount $BOOT_DEVICE /mnt/boot/efi
cp -r ../../ArchInstall /mnt/root/
echo cd in /root/ArchInstall/commands to continue
arch-chroot /mnt
