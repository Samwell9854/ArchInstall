source /etc/os-release
export ID
mkdir /etc/pacman.d/hooks
cp -r ../files/* /
#systemctl enable systemd-boot-update.service
sed -i 's/  ManageImages: false/  ManageImages: true/' /etc/zfsbootmenu/config.yaml
sed -i '6 a \ \ InitCPIO: true' /etc/zfsbootmenu/config.yaml
sed -i 's/  Enabled: true/  Enabled: false/' /etc/zfsbootmenu/config.yaml
sed -i ':a;N;$!ba;s/  Enabled: false/  Enabled: true/3' /etc/zfsbootmenu/config.yaml
sed -i 's/stubs\/linuxx64.efi.stub /stubs\/linuxx64.efi.stub\/linuxx64.efi.stub /' /etc/zfsbootmenu/config.yaml
#mkdir -p /boot/efi/EFI/zbm
#curl -o /boot/efi/EFI/zbm/vmlinuz.EFI -L https://get.zfsbootmenu.org/efi
#cp /boot/efi/EFI/zbm/vmlinuz.EFI /boot/efi/EFI/zbm/vmlinuz-backup.EFI
zfs set org.zfsbootmenu:commandline="rw quiet rd.vconsole.keymap=en net.ifnames=0 RESUME=none nvidia_drm.modeset=1" zroot/ROOT

#vim /etc/mkinitcpio.conf
# add zfs to MODULES
cp /etc/mkinitcpio.conf /etc/mkinitcpio.conf.bak
sed -i 's/MODULES=()/MODULES=(zfs)/' /etc/mkinitcpio.conf
sed -i 's/HOOKS=(.*/HOOKS=\(base udev autodetect modconf block keyboard zfs filesystems\)/' /etc/mkinitcpio.conf
# in HOOKS, add sd-zfs before filesystems; move keyboard hook before zfs; remove fsck (if not using ext3/ext4); replace udev with systemd; replace keymap and consolefont with sd-vconsole
mkinitcpio -p linux
generate-zbm
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.target
systemctl enable zfs.target
systemctl enable zfs-zed.service
systemctl enable zfs-scrub-weekly@zroot.timer
zgenhostid -f
systemctl enable systemd-timesyncd
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable paccache.timer
echo *** select man-db ***
pacman --noconfirm -S dhcpcd dosfstools gptfdisk htop inetutils linux-firmware logrotate lsof man man-pages nmap openssh screen smartmontools strace sysfsutils usbutils wget xfsprogs
echo Done in chroot, you may 'exit' back to live environment
