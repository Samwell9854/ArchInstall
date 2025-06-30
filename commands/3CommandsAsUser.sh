# As user, install AUR and ZFS packages
mkdir ~/AUR
cd ~/AUR
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
#echo ***** Select mkinitcpio *****
# CHANGE TO DKMS
#yay -S zfs-linux mkinitcpio-sd-zfs
yay -S zfs-dkms zfsbootmenu plzip
echo Done as user, you may 'exit' back to root
