

# Install chef
$download_url = 'https://packages.chef.io/files/stable/chef/17.1.35/windows/2016/chef-client-17.1.35-1-x64.msi'


#replace for testing with 12.8.1
$download_url = 'https://packages.chef.io/files/stable/chef/12.8.1/windows/2008r2/chef-client-12.8.1-1-x86.msi'

(New-Object System.Net.WebClient).DownloadFile($download_url, 'C:\\Windows\\Temp\\chef.msi')
Start-Process 'msiexec' -ArgumentList '/qb /i C:\\Windows\\Temp\\chef.msi' -NoNewWindow -Wait







# Create first-boot.json
set-content c:\chef\first-boot.json '
{
   "run_list" :[
   "role[base]"
   ]
}
'
 
$NODE_NAME= hostname
 
# move in validator
cp c:\mysync\testorg-validator.pem c:\chef\
mkdir c:\chef\trusted_certs\
cp c:\mysync\chef-server_test.crt c:\chef\trusted_certs\
 
# Create client.rb
set-content c:\chef\client.rb "
log_location            STDOUT
chef_server_url         'https://chef-server.test/organizations/testorg'
validation_client_name  'testorg-validator'
validation_key          'c:\chef\testorg-validator.pem'
node_name               '$NODE_NAME'
"


$hostsPath = "$env:windir\System32\drivers\etc\hosts"



(get-content $hostsPath) + '192.168.33.201 chef-server.test' | Out-File $hostsPath -enc ascii





chef-client --chef-license 'accept'
chef-client -j c:/chef/first-boot.json
chef-client --daemonize --interval 60 --splay 60