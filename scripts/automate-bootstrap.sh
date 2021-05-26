
#!/usr/bin/env bash

sysctl -w vm.max_map_count=262144
sysctl -w vm.dirty_expire_centisecs=20000
sysctl -p

# get and install automate
curl -s https://packages.chef.io/files/current/automate/latest/chef-automate_linux_amd64.zip | gunzip - > chef-automate && chmod +x chef-automate
sudo ./chef-automate deploy --accept-terms-and-mlsa
cat > data-collector-token.toml <<EOF
[auth_n.v1.sys.service]
a1_data_collector_token = "KGN0YhXlXhQwhFxTnXLTPhfObKs="
EOF
./chef-automate config patch data-collector-token.toml


# install docker

DEBIAN_FRONTEND=noninteractive apt-get install docker -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository 'deb [arch=amd64] https://download.docker.com/linux/ubuntu xenial stable'
apt-get update
apt-cache policy docker-ce
DEBIAN_FRONTEND=noninteractive apt-get install -y docker-ce
apt-get clean



# populate some base compliance node data
docker pull learnchef/compliance-loader-pass:latest
docker pull learnchef/compliance-loader-fail:latest

sudo crontab -l | { cat; echo "*/3 * * * * sudo docker run learnchef/compliance-loader-pass:latest"; } | sudo crontab 
sudo crontab -l | { cat; echo "*/4 * * * * sudo docker run learnchef/compliance-loader-fail:latest"; } | sudo crontab 


# create / move shared files
sudo cp /hab/svc/automate-load-balancer/data/chef-automate.test.cert /opt/mysync/automate.cert
sudo cp ./automate-credentials.toml /opt/mysync/



# and finally
echo 'Server is up. Please log in at https://chef-automate.test/'
echo 'You may log in using credentials provided below:'
cat ./automate-credentials.toml