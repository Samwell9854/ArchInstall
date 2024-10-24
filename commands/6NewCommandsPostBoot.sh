# Configure DNS
mv /etc/resolv.conf /etc/resolv.conf.bak
ln -sf /run/systemd/resolve/stub-resolv.conf /etc/resolv.conf
sudo mkdir /etc/systemd/resolved.conf.d
echo '[Resolve]' | sudo tee /etc/systemd/resolved.conf.d/dnssec.conf
echo 'DNSSEC=allow-downgrade' | sudo tee -a /etc/systemd/resolved.conf.d/dns.conf

# Firmware file missing (SOF Intel)
cd /usr/src
git clone https://github.com/thesofproject/sof-bin.git
cd sof-bin/v2.2.x
rsync -a sof*v2.2 /lib/firmware/intel/
ln -s sof-v2.2 /lib/firmware/intel/sof
ln -s sof-tplg-v2.2 /lib/firmware/intel/sof-tplg
rsync tools-v2.2/* /usr/local/bin
