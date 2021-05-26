#!/usr/bin/env bash

sudo su

touch ./patch.toml
cat > './patch.toml' << EOF
[deployment.v1.svc]
products=["automate", "infra-server"]
[global.v1]
fqdn = "chef-automate.test"
EOF

chef-automate config patch ./patch.toml

sleep 1
# create test user login
mkdir ~/.chef
chef-server-ctl user-create autotestuser test user testuser@test.user 'PASSWORD!' --filename ~/.chef/testuser.pem

# create test org
chef-server-ctl org-create autotestorg "test org" --association_user autotestuser --filename ~/.chef/testorg-validator.pem

cp ~/.chef/testorg-validator.pem /opt/mysync/


chef-automate config show | grep cert > certtxt.txt
sed -i 's/cert = "//' certtxt.txt 
sed -i 's/"//' certtxt.txt 
cp certtxt.txt  /opt/mysync/chef-server_test.crt
