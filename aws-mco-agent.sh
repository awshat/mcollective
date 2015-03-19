#!/bin/bash

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

yum install mcollective mcollective-common  -y

cd /etc/mcollective

# customize settings for /etc/mcollective/server.cfg
#   i.e. change the host to the hostname of the mcollective activemq host and port 61613
#   by default this will point it at host "localhost" port "61613"
#	FOR AGENTS CHANGE "localhost" to your mcollective activemq server stack
wget https://github.com/awshat/mcollective/server.cfg

# customize settings for /etc/mcollective/facts.yaml
#   i.e. add environment=[dev,qa,prod] role=[web,app,sql,nosql] farm=[blue,green]
#   by default this will environment=dev role=web farm=blue
wget https://github.com/awshat/mcollective/facts.yaml

# make opensource mcollective installation work on amazon linux...
cp -R /usr/lib/ruby/site_ruby/1.8/* /usr/lib64/ruby/vendor_ruby/2.0/
ln -s /usr/lib64/ruby/vendor_ruby/2.0/mcollective /usr/libexec/mcollective

# install fleet command and control via  mcollective-shell-plugin "mco shell run" 
cd /usr/lib64/ruby/vendor_ruby/2.0/
wget https://github.com/awshat/mcollective/mcollective-shell-plugin.tgz 
tar -xzvf mcollective-shell-plugin.tgz
rm mcollective-shell-plugin.tgz

gem install stomp 
/etc/init.d/mcollective start 
/sbin/chkconfig --levels 2345 mcollective on
