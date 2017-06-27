FROM ffquintella/docker-puppet:latest

MAINTAINER Felipe Quintella <docker-jira@felipe.quintella.email>

LABEL version="7.3.8.1"
LABEL description="This image contais the jira application to be used \
as a server."


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

ENV JAVA_HOME "/opt/java_home/java_home"
ENV JIRA_VERSION "7.3.8"
ENV JIRA_INSTALLDIR "/opt/jira"
ENV JIRA_HOME "/opt/jira-home"


ENV FACTER_JIRA_VERSION $JIRA_VERSION
ENV FACTER_JIRA_INSTALLDIR $JIRA_INSTALLDIR
ENV FACTER_JIRA_HOME $JIRA_HOME

ENV FACTER_JAVA_HOME "/opt/java_home"
ENV FACTER_JAVA_VERSION "8"
ENV FACTER_JAVA_VERSION_UPDATE "131"
ENV FACTER_JAVA_VERSION_BUILD "11"
ENV FACTER_JAVA_VERSION_HASH "d54c1d3a095b4ff2b6607d096fa80163"


ENV FACTER_PRE_RUN_CMD ""
ENV FACTER_EXTRA_PACKS ""

# Puppet stuff all the instalation is donne by puppet
# Just after it we clean up everthing so the end image isn't too big
RUN mkdir /etc/puppet; mkdir /etc/puppet/manifests ; mkdir /etc/puppet/modules ; mkdir /opt/scripts
COPY manifests /etc/puppet/manifests/
COPY modules /etc/puppet/modules/
COPY start-service.sh /opt/scripts/start-service.sh
RUN chmod +x /opt/scripts/start-service.sh ; /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/base.pp  ;\
 yum clean all ; rm -rf /tmp/* ; rm -rf /var/cache/* ; rm -rf /var/tmp/* ; rm -rf /var/opt/staging

# Ports Jira web interface
EXPOSE 8080/tcp

WORKDIR $FACTER_JIRA_INSTALLDIR

# Configurations folder, install dir
VOLUME  $JIRA_HOME

#CMD /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp
CMD ["start-service"]
