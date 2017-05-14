require 'json'

Vagrant.configure("2") do |config|
  config.vm.box = "centos/7"
  config.vbguest.auto_update = true

  if Vagrant.has_plugin?("vagrant-cachier")
    config.cache.scope = :box
  end

  config.vm.provider "virtualbox" do |v|
    # ネットワークアダプタに変更を加える
    v.customize ['modifyvm', :id, '--nicpromisc1', 'allow-all']
    v.customize ['modifyvm', :id, '--nicpromisc2', 'allow-all']
  end

  config.vm.network "private_network", ip: "192.168.33.10", auto_config: false

  # riak-cluster
  config.vm.network "forwarded_port", guest: 8087, host: 8087
  config.vm.network "forwarded_port", guest: 8098, host: 8098
  config.vm.network "forwarded_port", guest: 8187, host: 8187
  config.vm.network "forwarded_port", guest: 8198, host: 8198

  # rabbit-cluster
  config.vm.network "forwarded_port", guest: 5672, host: 5672
  config.vm.network "forwarded_port", guest: 15672, host: 15672
  config.vm.network "forwarded_port", guest: 5673, host: 5673
  config.vm.network "forwarded_port", guest: 15673, host: 15673
  config.vm.network "forwarded_port", guest: 5674, host: 5674
  config.vm.network "forwarded_port", guest: 15674, host: 15674

  # mysql-cluster
  config.vm.network "forwarded_port", guest: 3306, host: 3306
  config.vm.network "forwarded_port", guest: 3307, host: 3307

  config.vm.provider "virtualbox" do |vb|
    vb.gui = false
  
    vb.memory = "8192"
  end

  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  config.omnibus.chef_version = :latest
  config.omnibus.cache_packages = true
  config.berkshelf.enabled = true
  config.berkshelf.berksfile_path = "./chef-repo/Berksfile"

  config.vm.provision "chef_solo" do |chef|
    chef.cookbooks_path = ["./chef-repo/cookbooks","./chef-repo/site-cookbooks"]
    json_data = JSON.load(open('./chef-repo/nodes/yell.json'))
    chef.run_list = json_data['run_list']
  end
end
