#!/usr/bin/env bash

echo 192.168.33.199 chef-automate.test | sudo tee -a /etc/hosts
echo 192.168.33.200 chef-habitat.test | sudo tee -a /etc/hosts
echo 192.168.33.201 chef-server.test | sudo tee -a /etc/hosts