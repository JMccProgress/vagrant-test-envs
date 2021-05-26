#!/usr/bin/env bash 


sudo sh /opt/mysync/base-bootstrap.sh

# Do some chef pre-work
/bin/mkdir -p /etc/chef
/bin/mkdir -p /var/lib/chef
/bin/mkdir -p /var/log/chef


cd /etc/chef/

# Install chef
curl -L https://omnitruck.chef.io/install.sh | bash || error_exit 'could not install chef'

# Create first-boot.json
cat > "/etc/chef/first-boot.json" << EOF
{
   "run_list" :[
   "role[base]"
   ]
}
EOF

NODE_NAME="$(hostname)"

# move in validator
cp /opt/mysync/testorg-validator.pem /etc/chef/
cp /opt/mysync/chef-server_test.crt /etc/chef/trusted_certs

# Create client.rb
cat > '/etc/chef/client.rb' << EOF
log_location            STDOUT
chef_server_url         'https://chef-server.test/organizations/testorg'
validation_client_name  'testorg-validator'
validation_key          '/etc/chef/testorg-validator.pem'
node_name               "${NODE_NAME}"
EOF



chef-client --chef-license 'accept'
chef-client -j /etc/chef/first-boot.json
sudo chef-client --daemonize --interval 60 --splay 60
sudo crontab -l | { cat; echo "@reboot sudo chef-client --daemonize --interval 60 --splay 60"; } | sudo crontab 