# Configure disk and partition, then arch-chroot
source /etc/os-release
export ID
export BOOT_DISK="/dev/sda"
#export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}${BOOT_PART}"
#export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"

zfs set mountpoint=/home zroot/data/home
zfs set mountpoint=/root zroot/data/home/root
zfs set mountpoint=/usr zroot/data/usr
zfs set mountpoint=/var zroot/data/var
zfs set org.zfsbootmenu:commandline="rw quiet rd.vconsole.keymap=en net.ifnames=0 RESUME=none nvidia_drm.modeset=1" zroot/ROOT

zpool export zroot
zpool import -N -R /mnt zroot
zfs mount zroot/ROOT/${ID}
zfs mount -a
zpool set bootfs=zroot/ROOT/${ID} zroot
zpool set cachefile=/etc/zfs/zpool.cache zroot
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache
mount "$BOOT_DEVICE" /mnt/boot/efi

mv /mnt/etc/fstab /mnt/etc/fstab.bak
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i '/zroot/d' /mnt/etc/fstab

cp 99Restore-4* /mnt/root/
echo Run 99Restore file in /root to fix boot
arch-chroot /mnt
