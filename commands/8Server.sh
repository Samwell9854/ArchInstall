# docker
sudo pacman --noconfirm -S docker docker-compose
sudo usermod -a -G docker samuel
sudo systemctl enable docker.socket

# qemu libvirtd virt-manager iscsi
sudo pacman --noconfirm -S libvirt qemu-base qemu-block-iscsi virt-manager open-iscsi qemu-hw-display-qxl qemu-hw-display-virtio-gpu qemu-hw-display-virtio-gpu-pci qemu-hw-usb-redirect qemu-chardev-spice qemu-audio-spice
yay -S virtio-win
sudo systemctl enable iscsid.socket

# Bridged network
echo '
[Match]
Name=eth0

[Network]
Bridge=br0' | sudo tee /etc/systemd/network/20-eth0.network
echo '
[NetDev]
Name=br0
Kind=bridge' | sudo tee /etc/systemd/network/25-br0.netdev
echo '
[Match]
Name=br0

[Network]
DHCP=yes

[DHCPv4]
RouteMetric=100

[IPv6AcceptRA]
RouteMetric=100' | sudo tee /etc/systemd/network/25-br0.network
sudo systemctl enable systemd-networkd
