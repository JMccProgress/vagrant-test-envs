#!/usr/bin/env bash


apt-get update -y && apt-get upgrade -y && DEBIAN_FRONTEND=noninteractive apt-get install -y unzip
sleep 1
sysctl -w vm.max_map_count=262144
sysctl -w vm.dirty_expire_centisecs=20000
sysctl -p
timedatectl set-ntp true
sudo crontab -l | { cat; echo "@reboot sudo timedatectl set-ntp true"; } | sudo crontab 





