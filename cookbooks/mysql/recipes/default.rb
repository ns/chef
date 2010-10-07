#
# Cookbook Name:: mysql
# Recipe:: default
#
# Copyright 2008, OpsCode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

package "mysql-server" do
  action :install
end

package "mysql-devel" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse" ] => { "default" => "mysql-devel" },
    "default" => 'libmysqlclient-dev'
  )
  action :install
end

package "mysql-client" do
  package_name value_for_platform(
    [ "centos", "redhat", "suse" ] => { "default" => "mysql" },
    "default" => "mysql-client"
  )
  action :install
end

template "/etc/mysql/my.cnf" do
  owner 'root'
  group 'root'
  mode 0644
  source "my.conf.erb"
end

service "mysql" do
  service_name "mysql"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => false, :restart => true, :reload => true
  action :nothing
end

# service "mysql" do
#   supports :status => true, :restart => true, :reload => true
#   action :enable
# end

mysql_server_path = case node[:platform]
when "ubuntu","debian"
  "/var/lib/mysql"
else
  "/var/mysql"
end
  
# service "mysql" do
#   supports :status => true, :restart => true, :reload => true
#   action :stop
# end

service "mysql" do
  service_name "mysql"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
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

execute "install-mysql" do
  command "mv #{mysql_server_path} #{node[:mysql_db_path]}"
  not_if do FileTest.directory?(node[:mysql_db_path]) end
end

directory node[:mysql_db_path] do
  owner "mysql"
  group "mysql"
  mode 0755
  recursive true
end

link mysql_server_path do
 to node[:mysql_db_path]
end

# service "mysql" do
#   supports :status => true, :restart => true, :reload => true
#   action :start
# end
service "mysql" do
  service_name "mysql"
  if (platform?("ubuntu") && node.platform_version.to_f >= 10.04)
    restart_command "restart mysql"
    stop_command "stop mysql"
    start_command "start mysql"
  end
  supports :status => false, :restart => true, :reload => true
  action :start
end

execute "mysql-root-pass" do
  command "/usr/bin/mysqladmin -u root password '#{node[:mysql_root_pass]}'; true"
end if node[:mysql_root_pass]

# service "mysql" do
#   supports :status => true, :restart => true, :reload => true
#   action :start
# end