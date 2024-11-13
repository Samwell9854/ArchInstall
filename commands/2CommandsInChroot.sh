export HOSTNAME="lausercosamtux"
export KERNEL="linux"
# Configure the OS + ZFS repo
echo password for root
passwd
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
#hwclock --systohc
echo 'LANG=en_CA.UTF-8' > /etc/locale.conf
echo 'LANGUAGE=en_CA:en_US:en:C' >> /etc/locale.conf
echo 'LC_TIME=en_CA.UTF-8' >> /etc/locale.conf
echo 'LC_COLLATE=C' >> /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
locale-gen
source /etc/locale.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads.*/ParallelDownloads = 12/' /etc/pacman.conf
#sed -i 's/#IgnorePkg.*/IgnorePkg   = zfs-dkms/' /etc/pacman.conf
pacman -Syy
pacman -Fy
pacman --noconfirm -S vim pigz pbzip2 sudo base-devel git less intel-ucode amd-ucode "$KERNEL" "$KERNEL-headers" efibootmgr pacman-contrib ntfs-3g
echo 'EDITOR=vim' >> /etc/environment
sed -i.bak 's/#MAKEFLAGS=.*/MAKEFLAGS="-j$(nproc)"/' /etc/makepkg.conf
sed -i 's/RUSTFLAGS=.*/RUSTFLAGS="-C opt-level=2 -C target-cpu=native -C link-arg=-fuse-ld=mold"/' /etc/makepkg.conf
sed -i 's/gzip -c/pigz -c/' /etc/makepkg.conf
sed -i 's/bzip2 -c/pbzip2 -c/' /etc/makepkg.conf
sed -i 's/xz -c -z -/xz -c -z --threads=0 -/' /etc/makepkg.conf
echo "127.0.0.1 $HOSTNAME localhost" >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
chmod 740 /etc/sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
chmod 440 /etc/sudoers
useradd -m -G games,network,wheel,audio,optical,storage,video samuel
cp /etc/skel/.* /home/samuel/
chown -R samuel:samuel /home/samuel
echo password for samuel
passwd samuel
su samuel
