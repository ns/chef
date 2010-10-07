execute "add-mongodb-source" do
  command "echo \"deb http://downloads.mongodb.org/distros/ubuntu 10.4 10gen\" > /etc/apt/sources.list.d/opscode.list"
  action :run
end

execute "add-mongodb-source-key" do
  command "sudo apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10"
  action :run
end

execute "apt-update" do
  command "apt-get update"
  action :run
end

package "mongodb-stable" do
  action :install
end

# template "/etc/mysql/my.cnf" do
#   owner 'root'
#   group 'root'
#   mode 0644
#   source "my.conf.erb"
# end

service "mongodb" do
  service_name "mongodb"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mongodb"
    stop_command "stop mongodb"
    start_command "start mongodb"
  end
  supports :status => false, :restart => true, :reload => true
  action :nothing
end

mongodb_server_path = "/var/lib/mongodb"
  
service "mongodb" do
  service_name "mongodb"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mongodb"
    stop_command "stop mongodb"
    start_command "start mongodb"
  end
  supports :status => false, :restart => true, :reload => true
  action :stop
end

directory "/db" do
  owner "root"
  group "root"
  mode 0755
  recursive true
end

execute "install-mongodb" do
  command "mv #{mongodb_server_path} #{node[:mongodb_db_path]}"
  not_if do FileTest.directory?(node[:mongodb_db_path]) end
end

directory node[:mongodb_db_path] do
  owner "mongodb"
  group "mongodb"
  mode 0755
  recursive true
end

link mongodb_server_path do
 to node[:mongodb_db_path]
end

service "mongodb" do
  service_name "mongodb"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mongodb"
    stop_command "stop mongodb"
    start_command "start mongodb"
  end
  supports :status => false, :restart => true, :reload => true
  action :start
end

# if ['app_master', 'solo'].include?(node[:instance_role])
#   node[:applications].each do |app_name,data|
#     template "/data/#{app_name}/shared/config/mongodb.yml" do
#       source "mongodb.yml.erb"
#       owner node[:owner_name]
#       group node[:owner_name]
#       mode 0744
#       variables({
#         :app_name => app_name
#       })
#     end
#   end
# end