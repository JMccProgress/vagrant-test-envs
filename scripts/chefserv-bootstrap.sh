#!/usr/bin/env bash


# install chef infra server

if dpkg -l 'chef-server*'
then
    echo "chef server already installed"
else
    wget -q https://packages.chef.io/files/stable/chef-server/13.1.13/ubuntu/18.04/chef-server-core_13.1.13-1_amd64.deb

    sudo dpkg -i chef-server-core_*.deb
    rm chef-server-core_*.deb

    sudo chef-server-ctl reconfigure --chef-license=accept
fi



# install chef manage
if dpkg -l 'chef-manage*'
then
    echo "chef manage already installed"
else
    sudo chef-server-ctl install chef-manage
    sudo chef-server-ctl reconfigure
    sudo chef-manage-ctl reconfigure
fi

# create test user login
mkdir ~/.chef
sudo chef-server-ctl user-create testuser test user testuser@test.user 'PASSWORD!' --filename ~/.chef/testuser.pem

# create test org
sudo chef-server-ctl org-create testorg "test org" --association_user testuser --filename ~/.chef/testorg-validator.pem

cp ~/.chef/testorg-validator.pem /opt/mysync/
cp /var/opt/opscode/nginx/ca/chef-server.test.crt /opt/mysync/chef-server_test.crt

# connect to automate




# connect to nodes