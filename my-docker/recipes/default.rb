docker_installation_package 'default' do
#  version '17.04.0.ce'
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
  notifies :run, "execute[modify_interface]"
end

docker_image 'harbur/rabbitmq-cluster' do
  source '/vagrant/docker-repo/docker-rabbitmq-cluster'
  action :build_if_missing
end

#centos7
execute 'modify_interface' do
  action :nothing
  command "ip addr del 192.168.33.10/24 dev eth1 && brctl addif docker1 eth1"
end

docker_compose_application 'rabbitmq-cluseter' do
  action :up
  compose_files [ '/vagrant/docker-repo/docker-rabbitmq-cluster/docker-compose.yml' ]
end
