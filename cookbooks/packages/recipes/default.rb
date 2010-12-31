#
# Cookbook Name:: packages
# Recipe:: default
#

for package_name in node[:packages]
  package package_name
end