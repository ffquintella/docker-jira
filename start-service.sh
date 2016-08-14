#!/bin/bash

set -e

/opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp

while [ ! -f ${FACTER_BAMBOO_HOME}/logs/atlassian-jira.log ]
do
  sleep 2
done
ls -l ${FACTER_BAMBOO_HOME}/logs/atlassian-jira.log

tail -n 0 -f ${FACTER_BAMBOO_HOME}/logs/atlassian-jira.log &
wait
