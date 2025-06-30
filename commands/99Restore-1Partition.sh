# Configure disk and partition, then arch-chroot
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

wipefs -a "$POOL_DISK"
wipefs -a "$BOOT_DISK"
sgdisk --zap-all "$POOL_DISK"
sgdisk --zap-all "$BOOT_DISK"
sgdisk -n "${BOOT_PART}:1m:+512m" -t "${BOOT_PART}:ef00" "$BOOT_DISK"
sgdisk -n "${POOL_PART}:0:0" -t "${POOL_PART}:bf00" "$POOL_DISK"

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
             -o compatibility=openzfs-2.2-linux \
             -m none                            \
             zroot "$POOL_DEVICE"
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=/ -o canmount=noauto zroot/ROOT/${ID}
zfs create -o mountpoint=none -o canmount=off zroot/data
zfs create -V 8G -b 8192                  \
           -o compression=zle             \
           -o logbias=throughput          \
           -o sync=always                 \
           -o primarycache=metadata       \
           -o secondarycache=none         \
           -o com.sun:auto-snapshot=false \
           zroot/swap
mkswap -f /dev/zvol/zroot/swap
swapon /dev/zvol/zroot/swap
mkfs.vfat -F32 "$BOOT_DEVICE"
