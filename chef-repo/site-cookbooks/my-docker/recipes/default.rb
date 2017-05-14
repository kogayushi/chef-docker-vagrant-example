docker_installation_package 'default' do
  action :create
end

include_recipe 'docker_compose::installation'

docker_service_manager 'default' do
  action :start
end

docker_network 'shared_nw' do
  driver 'bridge'
  driver_opts Hash[{"com.docker.network.bridge.name" => "docker1"}]
  subnet '192.168.33.0/24'
  gateway '192.168.33.10'
  action :create
end

template '/etc/sysconfig/network-scripts/ifcfg-eth1' do
  source 'ifcfg-eth1'
  notifies :run, 'execute[restart_network]', :immediately
end

execute 'restart_network' do
  action :nothing
  command "systemctl restart network"
end

#docker_image 'harbur/rabbitmq-cluster' do
#  source '/vagrant/docker-repo/docker-rabbitmq-cluster'
#  action :build_if_missing
#end

docker_compose_application 'rabbitmq-cluseter' do
  action :up
  compose_files [ '/vagrant/docker-repo/docker-rabbitmq-cluster/docker-compose.yml' ]
end

docker_compose_application 'riak-cluseter' do
  action :up
  compose_files [ '/vagrant/docker-repo/docker-riak-kv-cluster/docker-compose.yml' ]
end

docker_compose_application 'mysql-cluseter' do
  action :up
  compose_files [ '/vagrant/docker-repo/docker-mysql-cluster/docker-compose.yml' ]
end
