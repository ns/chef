#!/bin/sh

echo "deb http://apt.opscode.com/ lucid main" > /etc/apt/sources.list.d/opscode.list
curl http://apt.opscode.com/packages@opscode.com.gpg.key | apt-key add -
apt-get update
apt-get -y upgrade
apt-get -y install gcc ruby ri rdoc ruby-dev libopenssl-ruby1.8 rubygems

# cd /tmp
# wget http://rubyforge.org/frs/download.php/71100/ruby-enterprise_1.8.7-2010.02_i386_ubuntu10.04.deb
# dpkg -i ruby-enterprise_1.8.7-2010.02_i386_ubuntu10.04.deb
gem install rubygems-update --no-ri --no-rdoc
export PATH=/var/lib/gems/1.8/bin:$PATH
update_rubygems
gem install chef ohai --no-ri --no-rdoc

# ln -s /usr/bin/ruby1.9 /usr/bin/ruby
# ln -s /usr/bin/ri1.9 /usr/bin/ri
# ln -s /usr/bin/rdoc1.9 /usr/bin/rdoc
# ln -s /usr/bin/gem1.9 /usr/bin/gem

# echo "PATH=$PATH:/var/lib/gems/1.9.0/bin" > /etc/environment