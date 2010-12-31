class Chef
  class Recipe
    def monitrc(name, variables={})
      Chef::Log.info("Making monitrc for: #{name}")
      template "/etc/monit/conf.d/#{name}.monitrc" do
        owner "root"
        group "root"
        mode 0644
        source "#{name}.monitrc.erb"
        variables variables
        # notifies :run, resources(:execute => "restart-monit")
        action :create
      end
      service "monit" do
        supports :status => false, :restart => true, :reload => true
        action [ :restart ]
      end
    end
  end
end  