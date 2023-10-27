mkdir /etc/pacman.d/hooks
cp -r ../files/* /
#systemctl enable systemd-boot-update.service
sed -i 's/  ManageImages: false/  ManageImages: true/' /etc/zfsbootmenu/config.yaml
sed -i '6 a \ \ InitCPIO: true' /etc/zfsbootmenu/config.yaml
sed -i 's/  Enabled: true/  Enabled: false/' /etc/zfsbootmenu/config.yaml
sed -i ':a;N;$!ba;s/  Enabled: false/  Enabled: true/3' /etc/zfsbootmenu/config.yaml
generate-zbm
zfs set org.zfsbootmenu:commandline="rw quiet rd.vconsole.keymap=en net.ifnames=0 RESUME=none nvidia_drm.modeset=1" zroot/ROOT/${ID}

#vim /etc/mkinitcpio.conf
# add zfs to MODULES
# MODULES=(zfs)
# in HOOKS, add sd-zfs before filesystems; move keyboard hook before zfs; remove fsck (if not using ext3/ext4); replace udev with systemd; replace keymap and consolefont with sd-vconsole
systemctl enable zfs-import-cache.service
systemctl enable zfs-import.target

# Do this outside of chroot helps???
mkdir /etc/zfs/zfs-list.cache
#ln -s /usr/lib/zfs/zed.d/history_event-zfs-list-cacher.sh /etc/zfs/zed.d  ## already there
systemctl enable zfs.target
systemctl enable zfs-zed.service
touch /etc/zfs/zfs-list.cache/zroot

systemctl enable zfs-scrub-weekly@zroot.timer
zgenhostid $(hostid)
mkinitcpio -p linux
systemctl enable systemd-networkd.service
systemctl enable systemd-resolved.service
systemctl enable paccache.timer #does not exist??
echo *** select man-db ***
pacman --noconfirm -S dhcpcd dosfstools gptfdisk htop inetutils linux-firmware logrotate lsof man man-pages nmap openssh pacman-contrib screen smartmontools strace sysfsutils usbutils wget xfsprogs
exit
