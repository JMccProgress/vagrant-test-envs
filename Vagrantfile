begin

  # what are the base setup details
  CFG_BOX      = 'bento/ubuntu-20.04'

  ######## to make use of
  AUTOMATE_VERS = '0.0.0'
  INFRA_SERVER_VERS = '0.0.0'
  INFRA_CLIENT_VERS = '0.0.0'
  HAB_VERS = '0.0.0'


  # how many nodes
  WEB_NODE_COUNT = 1

  # do you want a combined automate and chef infra server.
  AUTOMATE_INFRA_COMBINED = false

  # do you want to build a habitat server
  BUILD_HAB_SERVER = true

  base_complete = true


  basecheck = `vagrant box list`
  puts basecheck


  if not basecheck.include? "mybase" then
    puts "NO BASE BOX"
    puts "\\\\\  Run first_run.sh   /////"
    exit
  end


  Vagrant.configure(2) do |config|


    cmd = `echo 'Hello from Vagrant!'` 
    puts cmd
    
    config.vm.define "base" do |base|

      base.vm.provider "virtualbox" do |v|
        v.memory = 4096
        v.cpus = 4
        v.name = "base"
      end

      base.vm.box = CFG_BOX
      
      value = (base.vm.provision :shell, path: "scripts/base-bootstrap.sh")  
      puts value
    
    end
  end


  
    Vagrant.configure(2) do |config|
      config.vm.define "automate" do |automate|
        automate.vm.hostname = 'chef-automate.test'
        
        automate.vm.provider "virtualbox" do |v|
          v.memory = 4096
          v.cpus = 4
          v.name = "chef-automate-server"
        end

        automate.vm.box = "mybase"
        
        automate.vm.synced_folder ".", "/opt/mysync", create: true
        
        automate.vm.network 'private_network', ip: '192.168.33.199'

        automate.vm.provision "shell", inline: "sudo hostname -f"

        automate.vm.provision :shell, path: "scripts/automate-bootstrap.sh"
        automate.vm.provision :shell, path: "scripts/hostnames.sh"

        if AUTOMATE_INFRA_COMBINED then
          automate.vm.provision :shell, path: "scripts/automate-install-infra.sh"
          automate.vm.network 'private_network', ip: '192.168.33.201'
        end
        

      end

      
      if BUILD_HAB_SERVER then
        config.vm.define "habserv" do |habserv|
          
          habserv.vm.hostname = 'chef-habitat.test'
          habserv.vm.box = "mybase"
          habserv.vm.synced_folder ".", "/opt/mysync", create: true
          habserv.vm.network 'private_network', ip: '192.168.33.200'
          
          habserv.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 4
            v.name = "chef-habitat"
          end

          habserv.vm.provision :shell, path: "scripts/habserv-bootstrap.sh"
          habserv.vm.provision :shell, path: "scripts/hostnames.sh"

        end
      end  

      
      if not AUTOMATE_INFRA_COMBINED then
        config.vm.define "chefserv" do |chefserv|
          
          chefserv.vm.hostname = 'chef-server.test'
          chefserv.vm.box = 'mybase'
          chefserv.vm.synced_folder ".", "/opt/mysync", create: true
          chefserv.vm.network 'private_network', ip: '192.168.33.201'

          chefserv.vm.provider "virtualbox" do |v|
            v.memory = 4096
            v.cpus = 4
            v.name = "chef-infra-server"
          end
          
          chefserv.vm.provision :shell, path: "scripts/chefserv-bootstrap.sh"
          chefserv.vm.provision :shell, path: "scripts/hostnames.sh"

        end
      end

      (1..WEB_NODE_COUNT).each do |i|
        config.vm.define "web-node-#{i}" do |node|
          node.vm.box = 'mybase'
          node.vm.hostname = "web-node-#{i}.test"
          node.vm.synced_folder ".", "/opt/mysync", create: true
          node.vm.network 'private_network', ip: "192.168.44.#{i}", autoconfig: false

          node.vm.provider "virtualbox" do |v|
            v.name       = "web-node-#{i}"
            v.memory     = 2048
            v.cpus       = 1
            v.customize ['modifyvm', :id, '--audio', 'none']
          end
        
          node.vm.provision :shell, path: "scripts/hostnames.sh"
          node.vm.provision :shell, path: "scripts/web-node-bootstrap.sh"
          node.vm.provision "shell", inline: "echo hello from web node #{i}"
        end
      end

      config.vm.define "win-node" do |windows|
          
        windows.vm.hostname = 'win-node'
        windows.vm.box = 'tas50/windows_2012r2'
        windows.vm.synced_folder ".", "C:/mysync", create: true, mount_options: ["vers=3.0"]
        windows.vm.network 'private_network', ip: '192.168.55.101'

        windows.vm.provider "virtualbox" do |v|
          v.memory = 4096
          v.cpus = 4
          v.name = "win-node"
        end

        windows.vm.provision :shell, path: "scripts/win-node-bootstrap.ps1"
        windows.vm.provision :shell, path: "scripts/win-node-bootstrap.ps1"

      end


    end





rescue
  
  puts "Lets make one!"
  `vagrant box add hashicorp/bionic64 --name mybase`
  retry

end