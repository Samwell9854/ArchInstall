# Cloud files sync
sudo pacman -S nextcloud-client
yay -S onedrive-abraunegg ldc liblphobos

# Web
sudo pacman -S vivaldi vivaldi-ffmpeg-codecs libva-utils nvtop libfido2 intel-media-driver intel-gpu-tools libvdpau-va-gl profile-cleaner xf86-video-intel
yay -S vivaldi-update-ffmpeg-hook libva-nvidia-driver
sudo cp ~/.cache/yay/vivaldi-update-ffmpeg-hook/vivaldi-update-ffmpeg.hook /etc/pacman.d/hooks/50-vivaldi-update-ffmpeg.hook
## Enable in vivaldi:flags
# Override software rendering list
# GPU rasterization
# Zero-Copy rasterizer
# Enables Display Compositor to use a new gpu thread
# Out-of-process 2D canvas rasterization
# Enable system notifications

# GSConnect
yay -S gnome-shell-extension-gsconnect
sudo pacman -S python-nautilus

# Evolution EWS
sudo pacman -S evolution-ews

# zsh
sudo pacman -S zsh zsh-completions
sudo chsh -s /bin/zsh
chsh -s /bin/zsh
sudo pacman -S zoxide
## check for zoxide.vim for neovim plugin
sudo pacman -S ruby
yay -S oh-my-zsh-git

