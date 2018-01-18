#!/bin/bash
clear
echo "This script configures a bare install of Ubuntu Server 16.04 to mine Zcash with Nvidia cards."
sleep 2
echo ""
echo "It will install the following dependencies, Nvidia proprietary drivers, then configure X-server and restart."
echo ""
echo ""
echo ""
echo ""
sleep 2
echo ""
echo "The script will automatically proceed in 5 seconds.  To abort, press <CTRL>-C."
sleep 5
echo "Testing for network connectivity."
if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "The network is up."
else
  echo "Please check your internet connection."
  exit 1
fi
if [[ $EUID -ne 0 ]]; then
   echo "**This script must be run as root.**"
   exit 1
fi

echo "******"
echo "Installing dependencies, this will take a while..."
echo "******"
sleep 5
apt install -y --no-install-recommends xserver-xorg lightdm
apt install -y build-essential gcc make dkms libgtk-3-dev xdm xorg-dev
sleep 4
echo "******"
echo "Downloading Nvidia driver, version 384"
echo "******"
sleep 2
wget http://us.download.nvidia.com/XFree86/Linux-x86_64/384.111/NVIDIA-Linux-x86_64-384.111.run
sleep 4
echo "******"
echo "Download complete, purging existing Nvidia drivers and installing downloaded driver"
echo "******"
sleep 2
apt purge -y nvidia-*
chmod +x NVIDIA-Linux-x86_64-384.111.run
./NVIDIA-Linux-x86_64-384.111.run
rm NVIDIA-Linux-x86_64-384.111.run
sleep 4
echo "******"
echo "Nvidia driver installed"
echo "Blacklisting nouveau"
echo "******"
sleep 2
cat << EOF > /etc/modprobe.d/blacklist-nouveau.conf
blacklist nouveau
blacklist lbm-nouveau
options nouveau modeset=0
alias nouveau off
alias lbm-nouveau off
EOF

echo "options nouveau modeset=0" >> /etc/modprobe.d/nouveau-kms.conf
sleep 4
echo "******"
echo "Configuring x-server"
echo "******"
sleep 2
cat << EOF > /etc/X11/xdm/Xsetup
export PATH=/bin:/usr/bin:/sbin
export HOME=/root
export DISPLAY=:0
xset -dpms
xset s off
xhost +
EOF

nvidia-xconfig -a --allow-empty-initial-configuration --cool-bits=28 --use-display-device="DPF-0" --connected-monitor="DPF-0"

sed -i '/Driver/a Option "Interactive" "False"' /etc/X11/xorg.conf
sleep 2
echo "******"
echo "******"
echo "Install complete, restarting in 10 seconds."
echo "Please run 'install-2.sh' once logged in again."
echo "******"
echo "******"

sleep 10

shutdown -r now
