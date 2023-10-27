mkdir ~/AUR
cd ~/AUR
git clone https://aur.archlinux.org/yay.git
cd yay/
makepkg -si
#echo ***** Select mkinitcpio *****
# CHANGE TO DKMS
#yay -S zfs-linux mkinitcpio-sd-zfs
yay -S zfs-dkms zfsbootmenu
echo Done as user, you may 'exit' back to root

# if a package cannot be resolved, specific version may need to be manually installed)
# https://archive.archlinux.org/
# example:
#sudo pacman -U https://archive.archlinux.org/packages/l/linux/linux-6.5.5.arch1-1-x86_64.pkg.tar.zst
#exit
