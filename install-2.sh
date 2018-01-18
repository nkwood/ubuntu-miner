#!/bin/bash
clear
echo "This script continues immediately after restart initiated by install.sh."
sleep 2
echo ""
echo "It will test to ensure Nvidia is properly installed."
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
echo "Installing docker and nvidia-docker."
echo "******"
sleep 5
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


echo "******"
echo "Starting X server to enble overclocking and manual fan control."
sleep 1
echo ""
echo "The local display will go dark.  Please ensure you have working SSH access."
sleep 1
echo ""
echo "To exit back to the local terminal, press <CTRL> <ALT> <F1>."
sleep 10

X :1 & export DISPLAY=1
