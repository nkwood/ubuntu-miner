#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "**This script must be run as root.**"
   exit 1
fi
echo "Testing for network connectivity..."
echo ""
sleep 5
if ping -q -c 1 -W 1 google.com >/dev/null; then
  echo "The network is up."
  sleep 5
else
  echo "Please check your internet connection and restart the script."
  exit 1
fi
clear
echo "This script configures a bare install of Ubuntu Server 16.04 to mine Zcash with Nvidia cards using nvidia-docker2."
echo ""
echo ""
sleep 10
echo "It will install the following packages:"
echo "     xserver-xorg (no-recommends flag)"
echo "     lightdm (no-recommends flag)"
echo "     build-essential"
echo "     gcc"
echo "     make"
echo "     dkms"
echo "     libgtk-3-dev"
echo "     xdm"
echo "     xorg-dev"
echo "     nvidia-387 (proprietary drivers)"
echo "     nvidia-cuda-toolkit"
echo "     docker-ce"
echo "     nvidia-docker2"
sleep 10
echo ""
echo "Nouveau will be blacklisted, and the system will restart."
sleep 10
echo ""
echo "A dummy X server will start (required by nvidia-settings overclocking utility),"
echo "which may result in a blank screen from any local console, regardless of connection."
echo ""
echo "Installing and configuring SSH access is highly recommended."
echo ""
sleep 10
echo "The script will automatically proceed in 10 seconds.  To abort, press <CTRL>-C."
sleep 10
clear


echo "******"
echo "Installing packages, this will take a while..."
echo "******"
sleep 5
apt update
apt install -y --no-install-recommends xserver-xorg lightdm
apt install -y build-essential gcc make dkms libgtk-3-dev xdm xorg-dev
sleep 4
echo ""
echo "******"
echo "Adding graphics driver repository and installing nvidia-387 and nvidia-cuda-toolkit."
echo "******"
echo ""
sleep 2
apt purge -y nvidia-*
add-apt-repository ppa:graphics-drivers
apt update
apt install -y nvidia-387 nvidia-cuda-toolkit
sleep 10
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
echo ""
echo "******"
echo "Installing docker and nvidia-docker."
echo "******"
echo ""
sleep 2
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
curl -sL  https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
curl -sL https://nvidia.github.io/nvidia-docker/ubuntu16.04/amd64/nvidia-docker.list | \
 tee /etc/apt/sources.list.d/nvidia-docker.list
 apt update
 apt install -y docker-ce
 apt install -y nvidia-docker2
 pkill -SIGHUP dockerd
sleep 4
echo "******"
echo "Docker and nvidia-docker2 installed."
echo "******"
sleep 2
echo ""
echo "******"
echo "Configuring X server to start automatically every boot."
echo ""
echo "SSH access is highly preferred, but if you need to kill the X session, press"
echo "<CTRL>-<ALT>-<F1> to access the local console.  Note that the nvidia-settings"
echo "overclock utility will not work without an active X session."
echo "******"

#do magic




sleep 10
echo "Install complete, restarting in 10 seconds."
echo "Please run 'install-2.sh' once logged in again."
echo "******"
echo "******"

sleep 10

shutdown -r now
