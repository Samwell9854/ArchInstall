pacman -S xorg-server xorg-apps
# NVIDIA
pacman -S autorandr nvidia-open nvidia-utils nvidia-settings
pacman -S gnome gnome-extra networkmanager gvfs-goa fwupd gnome-tweaks webp-pixbuf-loader
systemctl enable gdm
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable autorandr --now
sudo usermod -a -G power,lp,uucp,users,rfkill samuel
sed -i 's/AllowHibernation=.*/AllowHibernation=no/' /etc/systemd/sleep.conf
sed -i 's/AllowSuspendThenHibernate=.*/AllowSuspendThenHibernate=no/' /etc/systemd/sleep.conf
sed -i 's/AllowHybridSleep=.*/AllowHybridSleep=no/' /etc/systemd/sleep.conf
sed -i 's/SuspendState=.*/SuspendState=freeze/' /etc/systemd/sleep.conf
# Remove GNOME useless crap
pacman --noconfirm -Rs gnome-2048 gnome-builder gnome-chess gnome-games gnome-klotski gnome-mahjongg gnome-mines gnome-nibbles gnome-recipes gnome-robots gnome-sudoku gnome-taquin gnome-tetravex gnome-tour devhelp five-or-more four-in-a-row glade hitori lightsoff polari quadrapassel iagno swell-foop tali gedit epiphany
echo must reboot
sleep 3600

# Restore GNOME Settings (as user, put proper path)
dconf load / < dconf-settings.ini

# To save GNOME Settings changes
dconf dump / > dconf-settings.ini

