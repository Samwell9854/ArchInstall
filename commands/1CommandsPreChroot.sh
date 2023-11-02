source /etc/os-release
export ID
export BOOT_DISK="/dev/nvme0n1"
export BOOT_PART="1"
export BOOT_DEVICE="${BOOT_DISK}p${BOOT_PART}"
export POOL_DISK="/dev/nvme0n1"
export POOL_PART="2"
export POOL_DEVICE="${POOL_DISK}p${POOL_PART}"

wipefs -a "$POOL_DISK"
wipefs -a "$BOOT_DISK"
sgdisk --zap-all "$POOL_DISK"
sgdisk --zap-all "$BOOT_DISK"
sgdisk -n "${BOOT_PART}:1m:+512m" -t "${BOOT_PART}:ef00" "$BOOT_DISK"
sgdisk -n "${POOL_PART}:0m:-10m" -t "${POOL_PART}:bf00" "$POOL_DISK"

mkdir /etc/zfs/zfs-list.cache
touch /etc/zfs/zfs-list.cache/zroot
systemctl enable zfs.target
systemctl enable zfs-zed.service --now

zpool create -f -o ashift=12                    \
             -O compression=zstd-fast           \
             -O acltype=posixacl                \
             -O relatime=on                     \
             -O xattr=sa                        \
             -O dnodesize=legacy                \
             -O normalization=formD             \
             -O mountpoint=none                 \
             -O canmount=off                    \
             -O devices=off                     \
             -o autotrim=on                     \
             -o compatibility=openzfs-2.1-linux \
             -m none                            \
             zroot "$POOL_DEVICE"
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/${ID}
zfs create -o mountpoint=none -o canmount=off zroot/data
zfs create -o mountpoint=/home zroot/data/home
zfs create -o mountpoint=/root zroot/data/home/root
zfs create zroot/data/home/samuel
zfs create -o compression=off zroot/data/home/samuel/Downloads
zfs create -o mountpoint=/var -o canmount=off zroot/data/var
zfs create -o compression=zstd zroot/data/var/log
zfs create -V 8G -b 8192                  \
           -o compression=zle             \
           -o logbias=throughput          \
           -o sync=always                 \
           -o primarycache=metadata       \
           -o secondarycache=none         \
           -o com.sun:auto-snapshot=false \
           zroot/swap
mkswap -f /dev/zvol/zroot/swap
#create? usr/local var/games var/mail var/snap var/www var/lib/AccountsService var/lib/docker var/lib/libvirt var/lib/nfs
# tmpfs?
zpool export zroot
#zpool import -N -d /dev/disk/by-id -R /mnt zroot
zpool import -N -R /mnt zroot
zfs mount zroot/ROOT/${ID}
zfs mount -a
swapon /dev/zvol/zroot/swap
zpool set bootfs=zroot/ROOT/${ID} zroot
zpool set cachefile=/etc/zfs/zpool.cache zroot
mkdir -p /mnt/etc/zfs
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache
mkfs.vfat -F32 "$BOOT_DEVICE"
mkdir -p /mnt/boot/efi
mount "$BOOT_DEVICE" /mnt/boot/efi

mkdir /mnt/etc/zfs/zfs-list.cache
mv /etc/zfs/zfs-list.cache/zroot /mnt/etc/zfs/zfs-list.cache/zroot
ln -s /mnt/etc/zfs/zfs-list.cache/zroot /etc/zfs/zfs-list.cache/zroot

sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 12/' /etc/pacman.conf
pacstrap /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i '/zroot/d' /mnt/etc/fstab
sed -i 's/#en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/' /mnt/etc/locale.gen
sed -i 's/#fr_CA.UTF-8 UTF-8/fr_CA.UTF-8 UTF-8/' /mnt/etc/locale.gen
cp -r ../../ArchInstall /mnt/root/
echo cd in /root/ArchInstall/commands to continue
arch-chroot /mnt
