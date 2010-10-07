#
# Example Chef Solo Config
cookbook_path ["/etc/chef/cookbooks", "/etc/chef/site-cookbooks"]
log_level :debug
file_store_path File.join(File.dirname(__FILE__), '..')
file_cache_path File.join(File.dirname(__FILE__), '..')
Chef::Log::Formatter.show_time = false
