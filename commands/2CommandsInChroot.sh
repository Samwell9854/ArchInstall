# Configure the OS + ZFS repo
echo password for root
passwd
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
#hwclock --systohc
echo 'LANG=en_CA.UTF-8' > /etc/locale.conf
echo 'LANGUAGE=en_CA:en_US:en:C' >> /etc/locale.conf
echo 'LC_TIME=en_CA.UTF-8' >> /etc/locale.conf
echo 'LC_COLLATE=C' >> /etc/locale.conf
echo 'lausercosamtux' > /etc/hostname
locale-gen
source /etc/locale.conf
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads.*/ParallelDownloads = 12/' /etc/pacman.conf
#sed -i 's/#IgnorePkg.*/IgnorePkg   = zfs-dkms/' /etc/pacman.conf
pacman -Syy
pacman -Fy
pacman --noconfirm -S neovim sudo base-devel git less intel-ucode amd-ucode linux linux-headers efibootmgr pacman-contrib ntfs-3g
echo 'EDITOR=nvim' >> /etc/environment
echo '127.0.0.1 lausercotux localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
chmod 740 /etc/sudoers
sed -i 's/# %wheel ALL=(ALL:ALL) NOPASSWD: ALL/%wheel ALL=(ALL:ALL) NOPASSWD: ALL/' /etc/sudoers
chmod 440 /etc/sudoers
useradd -m -G games,network,wheel,audio,optical,storage,video samuel
cp /etc/skel/.* /home/samuel/
chown -R samuel:samuel /home/samuel
# Arch ZFS repo source: https://wiki.archlinux.org/title/Unofficial_user_repositories#archzfs
echo '
[archzfs]
# Origin Server - Finland
Server = http://archzfs.com/$repo/$arch
# Mirror - Germany
Server = http://mirror.sum7.eu/archlinux/archzfs/$repo/$arch
# Mirror - Germany
Server = http://mirror.sunred.org/archzfs/$repo/$arch
# Mirror - Germany
Server = https://mirror.biocrafting.net/archlinux/archzfs/$repo/$arch
# Mirror - India
Server = https://mirror.in.themindsmaze.com/archzfs/$repo/$arch
# Mirror - US
Server = https://zxcvfdsa.com/archzfs/$repo/$arch
' >> /etc/pacman.conf
pacman-key --populate archlinux
pacman-key --recv-keys F75D9D76
pacman-key --lsign-key F75D9D76
pacman --noconfirm -Syy archlinux-keyring
echo password for samuel
passwd samuel
su samuel
