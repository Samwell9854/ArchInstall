# Configure DNS
mv /etc/resolv.conf /etc/resolv.conf.bak
ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf

# Firmware file missing (SOF Intel)
cd /usr/src
git clone https://github.com/thesofproject/sof-bin.git
cd sof-bin/v2.2.x
rsync -a sof*v2.2 /lib/firmware/intel/
ln -s sof-v2.2 /lib/firmware/intel/sof
ln -s sof-tplg-v2.2 /lib/firmware/intel/sof-tplg
rsync tools-v2.2/* /usr/local/bin
