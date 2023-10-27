source /etc/os-release
export ID

echo password for root
passwd
ln -sf /usr/share/zoneinfo/America/Montreal /etc/localtime
#hwclock --systohc
echo 'LANG=en_CA.UTF-8' > /etc/locale.conf
#echo 'LANGUAGE=en_CA:en:C:fr_CA:fr' >> /etc/locale.conf
#echo 'LC_TIME=en_CA.UTF-8' >> /etc/locale.conf
echo 'LC_COLLATE=C' >> /etc/locale.conf
echo 'lausercosamtux' > /etc/hostname
locale-gen
sed -i 's/#Color/Color/' /etc/pacman.conf
sed -i 's/#ParallelDownloads = 5/ParallelDownloads = 12/' /etc/pacman.conf
sed -i 's/#IgnorePkg   =/IgnorePkg   = zfs-dkms/' /etc/pacman.conf
pacman --noconfirm -S vim sudo base-devel git less intel-ucode amd-ucode linux linux-headers efibootmgr pacman-contrib
echo '127.0.0.1 lausercotux localhost' >> /etc/hosts
echo '::1 localhost' >> /etc/hosts
visudo
useradd -m -G games,network,wheel,audio,optical,storage,video samuel
cp /etc/skel/.* /home/samuel/
chown -R samuel:samuel /home/samuel
# Arch ZFS repo source: https://wiki.archlinux.org/title/Unofficial_user_repositories#archzfs
echo '
[archzfs]
# Mirror - US
Server = https://zxcvfdsa.com/archzfs/$repo/$arch
# Origin Server - France
Server = http://archzfs.com/$repo/x86_64
# Mirror - Germany
Server = http://mirror.sum7.eu/archlinux/archzfs/$repo/x86_64
# Mirror - Germany
Server = https://mirror.biocrafting.net/archlinux/archzfs/$repo/x86_64
# Mirror - India
Server = https://mirror.in.themindsmaze.com/archzfs/$repo/x86_64
' >> /etc/pacman.conf
pacman-key --populate archlinux
pacman-key --recv-keys F75D9D76
pacman-key --lsign-key F75D9D76
pacman --noconfirm -Syy archlinux-keyring
echo password for samuel
passwd samuel
su samuel
