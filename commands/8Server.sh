# docker
sudo pacman --noconfirm -S docker
sudo usermod -a -G docker samuel
sudo systemctl enable docker.service

# qemu libvirtd virt-manager
sudo pacman --noconfirm -S bridge-utils libvirt qemu-base qemu-block-iscsi virt-manager virtio-win

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
