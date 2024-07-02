# Configure EFI boot, services and some apps
source /etc/os-release
export ID
mkdir /etc/pacman.d/hooks
cp -r ../files/* /
chown -R samuel:samuel /home/samuel/.config
sed -i 's/  ManageImages: false/  ManageImages: true/' /etc/zfsbootmenu/config.yaml
sed -i '6 a \ \ InitCPIO: true' /etc/zfsbootmenu/config.yaml
sed -i 's/  Enabled: true/  Enabled: false/' /etc/zfsbootmenu/config.yaml
sed -i ':a;N;$!ba;s/  Enabled: false/  Enabled: true/2' /etc/zfsbootmenu/config.yaml
zfs set org.zfsbootmenu:commandline="rw quiet rd.vconsole.keymap=en net.ifnames=0 RESUME=none nvidia_drm.modeset=1" zroot/ROOT
zed -F &
sleep 3
sed -Ei "s|/mnt/?|/|" /etc/zfs/zfs-list.cache/*

cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
sed -i 's/MODULES=()/MODULES=(zfs)/' /etc/mkinitcpio.conf
sed -i 's/HOOKS=(.*/HOOKS=\(base udev autodetect modconf keyboard block zfs filesystems\)/' /etc/mkinitcpio.conf
# If issues, use this command instead:
#sed -i 's/HOOKS=(.*/HOOKS=\(base udev autodetect modconf kms keyboard block zfs filesystems\)/' /etc/mkinitcpio.conf
mkinitcpio -p linux
generate-zbm
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.target
systemctl enable zfs.target
systemctl enable zfs-zed.service
systemctl enable zfs-scrub-weekly@zroot.timer
systemctl enable systemd-timesyncd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable paccache.timer
systemctl disable NetworkManager-wait-online.service
systemctl mask fwupd.service
systemctl mask systemd-udev-settle
echo *** select man-db ***
pacman --noconfirm -S dhcpcd dosfstools gptfdisk htop inetutils linux-firmware logrotate lsof man man-pages nmap openssh rsync screen smartmontools strace sysfsutils usbutils wget xfsprogs
echo Done in chroot, you may 'exit' back to live environment
