package "monit" do
  action :install
end

template "/etc/monit/monitrc" do
  owner "root"
  group "root"
  mode 0700
  variables :monit => node[:monit]
  source 'monitrc.erb'
end

directory "/var/monit" do
  owner "root"
  group "root"
  mode  0700
end

execute "enable-monit" do
  command "echo 'startup=1' > /etc/default/monit"
end

execute "restart-monit" do
  command "pkill -9 monit && monit"
  action :nothing
end