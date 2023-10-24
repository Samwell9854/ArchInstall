zpool create -f -o ashift=12                   \
             -O acltype=posixacl               \
             -O relatime=on                    \
             -O xattr=sa                       \
             -O dnodesize=legacy               \
             -O normalization=formD            \
             -O mountpoint=none                \
             -O canmount=off                   \
             -O devices=off                    \
             -R /mnt                           \
             -O compression=zstd-fast          \
             zroot /dev/nvme0n1p2
zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/default
zfs create -o mountpoint=/home zroot/data/home
zfs create -o mountpoint=/root zroot/data/home/root
zfs create zroot/data/home/samuel
zfs create -o compression=off zroot/data/home/samuel/Downloads
zfs create -o mountpoint=/var -o canmount=off zroot/var
zfs create -o compression=zstd zroot/var/log
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
zpool import -d /dev/disk/by-id -R /mnt zroot -N
zfs mount zroot/ROOT/default
zfs mount -a
swapon /dev/zvol/zroot/swap
zpool set cachefile=/etc/zfs/zpool.cache zroot
mkdir -p /mnt/etc/zfs
cp /etc/zfs/zpool.cache /mnt/etc/zfs/zpool.cache
mkfs.vfat /dev/nvme0n1p1
mkdir /mnt/efi
mkdir /mnt/boot
mount /dev/nvme0n1p1 /mnt/efi
pacstrap /mnt base
genfstab -U -p /mnt >> /mnt/etc/fstab
sed -i '/zroot/d' /mnt/etc/fstab
echo '/efi/env/org.zectl-default   /boot     none    rw,defaults,errors=remount-ro,bind    0 0' >> /mnt/etc/fstab
sed -i 's/#en_CA.UTF-8 UTF-8/en_CA.UTF-8 UTF-8/' /mnt/etc/locale.gen
sed -i 's/#fr_CA.UTF-8 UTF-8/fr_CA.UTF-8 UTF-8/' /mnt/etc/locale.gen
cp -r ../../ArchInstall /mnt/root/
echo cd in /root/ArchInstall to continue
arch-chroot /mnt
