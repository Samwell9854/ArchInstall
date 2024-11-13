export KERNEL="linux"
# Configure EFI boot, services and some apps
source /etc/os-release
export ID
mkdir /etc/pacman.d/hooks
cp -r ../files/* /
chown -R samuel:samuel /home/samuel/.config
zfs set org.zfsbootmenu:commandline="rw quiet rd.vconsole.keymap=en net.ifnames=0 RESUME=none nvidia_drm.modeset=1" zroot/ROOT
#zed -F &
#sleep 3
sed -Ei "s|/mnt/?|/|" /etc/zfs/zfs-list.cache/*

# No sleep at all
sed -i 's/#AllowHibernation=.*/AllowHibernation=no/' /etc/systemd/sleep.conf
sed -i 's/#AllowSuspendThenHibernate=.*/AllowSuspendThenHibernate=no/' /etc/systemd/sleep.conf
sed -i 's/#AllowHybridSleep=.*/AllowHybridSleep=no/' /etc/systemd/sleep.conf
sed -i 's/#AllowSuspend=.*/AllowSuspend=no/' /etc/systemd/sleep.conf

sudo usermod -a -G power,lp,uucp,users,rfkill samuel
# This line is here because it requires the pkg found in AUR before configuring - installed in script #3
sed -i 's/lzip -c/plzip -c/' /etc/makepkg.conf

sed -i.bak 's/MODULES=()/MODULES=(zfs)/' /etc/mkinitcpio.conf
sed -i 's/HOOKS=(.*/HOOKS=\(base udev autodetect modconf keyboard block zfs filesystems\)/' /etc/mkinitcpio.conf
# If issues, use this command instead:
#sed -i 's/HOOKS=(.*/HOOKS=\(base udev autodetect modconf kms keyboard block zfs filesystems\)/' /etc/mkinitcpio.conf
mkinitcpio -p $KERNEL
# ZBM fix for v2.3.0
sed -i.bak 's/ManageImages: false/ManageImages: true/' /etc/zfsbootmenu/config.yaml
sed -i '11s/Enabled: true/Enabled: false/' /etc/zfsbootmenu/config.yaml
#sed -i 's/Versions: false/Versions: 3/' /etc/zfsbootmenu/config.yaml    # version number of zfsbootmenu also gets written
sed -i '15s/Enabled: false/Enabled: true/' /etc/zfsbootmenu/config.yaml
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
#systemctl disable NetworkManager-wait-online.service
systemctl mask fwupd.service
#systemctl mask systemd-udev-settle
echo *** select man-db ***
pacman --noconfirm -S btop dosfstools gptfdisk iftop inetutils iperf linux-firmware logrotate lsof nmap openssh rsync screen smartmontools strace sysfsutils usbutils wget xfsprogs
echo Done in chroot, you may 'exit' back to live environment
