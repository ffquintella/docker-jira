#!/bin/bash

set -e

/opt/puppetlabs/puppet/bin/puppet apply -l /var/log/puppet.log --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp

while [ ! -f ${FACTER_JIRA_HOME}/log/atlassian-jira.log ]
do
  sleep 2
done
ls -l ${FACTER_JIRA_HOME}/log/atlassian-jira.log

tail -n 0 -f ${FACTER_JIRA_HOME}/log/atlassian-jira.log &
wait
