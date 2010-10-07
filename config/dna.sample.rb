require 'rubygems'
require 'json'

dna = {
  :user => "root",
  :mysql_root_pass => "pw",
  :nginx_user => "deploy",
  
  :users =>  [
    {
      :username => "user",
      :password => "pw",
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
        "..."
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
    "sendmail"
  ],
  
  :applications => [
    {
      :name => "site",
      :server_names => "site.com",
      :ports => [4000, 4001],
      :user => "deploy",
      :group => "deploy",
      :mysql_db_setup => false
      #:custom_nginx_conf => File.read(File.dirname(__FILE__), "../config/custom/some-custom-nginx.conf")
    }
  ],
  
  :gems => [
    "rake", 
    {:name => "mysql", :version => "2.7"},
    "thin",
    {:name => "rails", :version => "3.0.0"},
    "bundler"
  ],
  
  :monit => {
    :mailserver => "127.0.0.1",
    :alert_email => "email@domain.com"
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
    "nginx",
    "memcached",
    "cron",
    "monit",
    "gems",
    "rack_apps",
    "newsble"
  ]
}

open(File.dirname(__FILE__) + "/dna.json", "w").write(dna.to_json)