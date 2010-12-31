require 'rubygems'
require 'json'

dna = {
  :user => "root",
  # :mysql_root_pass => "",
  :nginx_user => "deploy",
  
  :users =>  [
    {
      :username => "user",
      :password => "test",
      :authorized_keys => "...",
      :shell => "/bin/zsh",
      :gid => 1000,
      :uid => 1000,
      :sudo => true,
      :custom_files  => [{
        :name => ".zshrc",
        :content => File.read(File.join(File.dirname(__FILE__), "/custom/zshrc"))
      }]
    },
    
    {
      :username => "deploy",
      :gid => 1101,
      :uid => 1101,
      :authorized_keys => ["..."],
      :shell => "/bin/zsh",
      :known_hosts => [
        "|1|cioyfz+ko9FIm1bhzvm5svcRlc0=|0rmtU2CoPLOTaA9xWwaeRGgbXlU= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==",
        "|1|fGtyHJzEGdCMdoUhXFtExfLnK+o=|0REhNAKK7SXbotUzdH2HkFnVQH8= ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ=="
      ],
      :ssh_keys => [
        {:file => "/etc/chef/files/users/deploy/id_rsa", :name => "id_rsa"}
      ]
    }
  ],
  
  :packages => [
    "imagemagick",
    "zsh",
    "zsh-doc",
    "vim",
    "g++",
    "libxml2-dev",
    "libxslt1-dev",
    "sendmail",
    "libhttpclient-ruby",
    "libcurl4-openssl-dev" # for patron gem
  ],
  
  :applications => [
    {
      :name => "app",
      :server_names => "app.com",
      :ports => [4000, 4001],
      :user => "deploy",
      :group => "deploy",
      :mysql_db_setup => false
      #:custom_nginx_conf => File.read(File.dirname(__FILE__), "../config/custom/some-custom-nginx.conf")
    }
  ],
  
  :gems => [
    "rake",
    # {:name => "mysql", :version => "2.7"},
    "thin",
    "mail",
    "thor",
    {:name => "rails", :version => "3.0.0"},
    "bundler"
  ],
  
  :monit => {
    :mailserver => "127.0.0.1",
    :alert_email => "email@email.com"
  },
  
  # :ebs_volumes => [
  #   {:device => "sdq1", :path => "/data"},
  #   {:device => "sdq2", :path => "/db"}
  # ],
  
  # :cronjobs => [
  #   {:name => "a_dumb_task",
  #    :minute => 30,
  #    :hour => nil,
  #    :day => nil,
  #    :month => nil,
  #    :weekday => nil,
  #    :user => "mr_app",
  #    :command => "date >> /data/look_cron_works.txt"
  #   }
  # ],
  
  :mongodb => {
    :mongodb_db_path => "/data/mongodb"
  },
  
  :recipes => [
    "packages",
    "users",
    "sudo",
    "openssh",
    # "ec2-ebs",
    # "mysql",
    "mongodb",
    "rabbitmq",
    "git",
    "logrotate",
    "nginx_source",
    "memcached",
    "cron",
    "monit",
    "gems",
    "rack_apps",
    # "your-app"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)