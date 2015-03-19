#!/bin/bash

rpm -ivh http://yum.puppetlabs.com/puppetlabs-release-el-6.noarch.rpm

yum install activemq -y
/etc/init.d/activemq start
/sbin/chkconfig --levels 2345 activemq on

yum install mcollective mcollective-client mcollective-common  -y

cd /etc/mcollective
#   by default this is setup for monolithic deploys configured for localhost port 61613
wget https://raw.githubusercontent.com/awshat/mcollective/master/client.cfg
#   by default this is setup for monolithic deploys configured for localhost port 61613
wget https://raw.githubusercontent.com/awshat/mcollective/master/server.cfg
# customize settings for /etc/mcollective/facts.yaml
#   i.e. add environment=[dev,qa,prod] role=[web,app,sql,nosql] farm=[blue,green]
#   by default this will environment=dev role=web farm=blue
wget https://raw.githubusercontent.com/awshat/mcollective/master/facts.yaml


# make opensource mcollective installation work on amazon linux...
cp -R /usr/lib/ruby/site_ruby/1.8/* /usr/lib64/ruby/vendor_ruby/2.0/
ln -s /usr/lib64/ruby/vendor_ruby/2.0/mcollective /usr/libexec/mcollective

# install fleet command and control via mcollective-shell-plugin "mco shell run" 
cd /usr/lib64/ruby/vendor_ruby/2.0/
wget https://raw.githubusercontent.com/awshat/mcollective/master/mcollective-shell-plugin.tgz
tar -xzvf mcollective-shell-plugin.tgz
rm mcollective-shell-plugin.tgz

gem install stomp 
/etc/init.d/mcollective start 
/sbin/chkconfig --levels 2345 mcollective on
