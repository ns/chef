package "gcc"
package "g++"
package "libpcre++-dev"
package "libssl-dev"
# include_recipe "runit"

nginx_version = node[:nginx][:version]
configure_flags = node[:nginx][:configure_flags].join(" ")
configure_flags = "#{configure_flags} --add-module=/tmp/nginx_http_push_module-0.692/"
# node.set[:nginx][:daemon_disable] = true

remote_file "/tmp/nginx-#{nginx_version}.tar.gz" do
  # source "http://sysoev.ru/nginx/nginx-#{nginx_version}.tar.gz"
  source "http://nginx.org/download/nginx-#{nginx_version}.tar.gz"
  action :create_if_missing
end

remote_file "/tmp/nginx_http_push_module-0.692.tar.gz" do
  source "http://pushmodule.slact.net/downloads/nginx_http_push_module-0.692.tar.gz"
  action :create_if_missing
end

bash "prepare_push_module" do
  cwd "/tmp"
  code <<-EOH
    tar zxf nginx_http_push_module-0.692.tar.gz
  EOH
end

bash "compile_nginx_source" do
  cwd "/tmp"
  code <<-EOH
    tar zxf nginx-#{nginx_version}.tar.gz
    cd nginx-#{nginx_version} && ./configure #{configure_flags}
    make && make install
  EOH
  creates node[:nginx][:src_binary]
end

[node[:nginx][:apps_dir], node[:nginx][:common_dir]].each do |dir|
  directory dir do
    action :delete
    recursive true
  end
end

[node[:nginx][:log_dir], node[:nginx][:apps_dir], node[:nginx][:common_dir]].each do |dir|
  directory dir do
    owner node[:nginx][:user]
    group node[:nginx][:user]
    mode 0755
    recursive true
  end
end

# directory node[:nginx][:log_dir] do
#   mode 0755
#   owner node[:nginx][:user]
#   action :create
# end

directory node[:nginx][:dir] do
  owner "root"
  group "root"
  mode "0755"
end

link node[:nginx][:linked_to] do
  to node[:nginx][:dir]
end

# unless platform?("centos","redhat","fedora")
#   runit_service "nginx"
# 
#   # service "nginx" do
#     # subscribes :restart, resources(:bash => "compile_nginx_source")
#   # end
# else
#   #install init db script
#   template "/etc/init.d/nginx" do
#     source "nginx.init.erb"
#     owner "root"
#     group "root"
#     mode "0755"
#   end
# 
#   #install sysconfig file (not really needed but standard)
#   template "/etc/sysconfig/nginx" do
#     source "nginx.sysconfig.erb"
#     owner "root"
#     group "root"
#     mode "0644"
#   end
# 
#   # #register service
#   # service "nginx" do
#   #   supports :status => true, :restart => true, :reload => true
#   #   action :enable
#   #   # subscribes :restart, resources(:bash => "compile_nginx_source")
#   # end
# end


%w{ sites-available sites-enabled conf.d }.each do |dir|
  directory "#{node[:nginx][:dir]}/#{dir}" do
    owner node[:nginx][:user]
    group node[:nginx][:user]
    mode "0755"
  end
end

# %w{nxensite nxdissite}.each do |nxscript|
#   template "/usr/sbin/#{nxscript}" do
#     source "#{nxscript}.erb"
#     mode "0755"
#     owner "root"
#     group "root"
#   end
# end

# service "nginx" do
#   supports :status => true, :restart => true, :reload => true
# end


template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode "0644"
  # notifies :restart, resources(:service => "nginx"), :immediately
  # notifies :reload, resources(:service => "nginx")
end

remote_file "#{node[:nginx][:dir]}/mime.types" do
  source "mime.types"
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode "0644"
  # notifies :restart, resources(:service => "nginx"), :immediately
  # notifies :reload, resources(:service => "nginx")
end

template "/data/nginx/common/app.conf" do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0644
  source "common.app.conf.erb"
end

template "/data/nginx/common/proxy.conf" do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0644
  source "common.proxy.conf.erb"
end

remote_file "/etc/logrotate.d/nginx" do
  owner node[:nginx][:user]
  group node[:nginx][:user]
  mode 0755
  source "nginx.logrotate"
  action :create
end

# service "nginx" do
#   action [ :enable, :start ]
# end

# kill the existing nginx, circumventing conf-file testing
execute "killall nginx || true"

# start our custom nginx
execute "#{node[:nginx][:dir]}/sbin/nginx" do
  not_if "test -f #{node[:nginx][:dir]}/logs/nginx.pid"
end