# Use this instead of CommandsPreChroot to mount the existing installation
source /etc/os-release
export ID
export BOOT_DISK="/dev/sda"
#export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}${BOOT_PART}"
#export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"
export POOL_DISK="/dev/sda"
#export POOL_DISK="/dev/nvme0n1"
export POOL_PART="2"
export POOL_DEVICE="${POOL_DISK}${POOL_PART}"
#export POOL_DEVICE="${POOL_DISK}p${POOL_PART}"

zpool import -N -R /mnt zroot
zfs mount zroot/ROOT/${ID}
zfs mount -a
mount $BOOT_DEVICE /mnt/boot/efi
cp -r ../../ArchInstall /mnt/root/
echo cd in /root/ArchInstall/commands to continue
arch-chroot /mnt
