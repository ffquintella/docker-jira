FROM ffquintella/docker-puppet:latest

MAINTAINER Felipe Quintella <docker-jira@felipe.quintella.email>

LABEL version="8.1.2.1"
LABEL description="This image contais the jira application to be used \
as a server."


ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LC_ALL=en_US.UTF-8

#https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-8.1.0.tar.gz
#https://product-downloads.atlassian.com/software/jira/downloads/atlassian-jira-software-8.2.2.tar.gz

ENV JAVA_HOME "/opt/java_home/java_home"
ENV JIRA_VERSION "8.1.2"
ENV JIRA_INSTALLDIR "/opt/jira"
ENV JIRA_HOME "/opt/jira-home"
ENV JIRA_CHECKSUM "f045c6c1ef35f6d11a84409286fb3bad"
ENV JIRA_DOWNLOAD_URL "https://www.atlassian.com/software/jira/downloads/binary/"

ENV FACTER_JIRA_VERSION $JIRA_VERSION
ENV FACTER_JIRA_CHECKSUM $JIRA_CHECKSUM
ENV FACTER_JIRA_INSTALLDIR $JIRA_INSTALLDIR
ENV FACTER_JIRA_HOME $JIRA_HOME
ENV FACTER_JIRA_DOWNLOAD_URL $JIRA_DOWNLOAD_URL

#https://download.oracle.com/otn/java/jdk/8u212-b10/59066701cf1a433da9770636fbc4c9aa/jre-8u212-linux-x64.rpm

ENV FACTER_JAVA_HOME "/opt/java_home"
ENV FACTER_JAVA_VERSION "8"
ENV FACTER_JAVA_VERSION_UPDATE "212"
ENV FACTER_JAVA_VERSION_BUILD "04"
ENV FACTER_JAVA_VERSION_HASH "59066701cf1a433da9770636fbc4c9aa"

ENV JVM_MINIMUM_MEMORY 1024m
ENV JVM_MAXIMUM_MEMORY 6144m

ENV FACTER_PRE_RUN_CMD ""
ENV FACTER_EXTRA_PACKS ""

# Puppet stuff all the instalation is donne by puppet
# Just after it we clean up everthing so the end image isn't too big
RUN mkdir /etc/puppet; mkdir /etc/puppet/manifests ; mkdir /etc/puppet/modules ; mkdir /opt/scripts
COPY manifests /etc/puppet/manifests/
COPY modules /etc/puppet/modules/
COPY start-service.sh /opt/scripts/start-service.sh
RUN chmod +x /opt/scripts/start-service.sh ; \
    /opt/puppetlabs/puppet/bin/puppet apply --modulepath=/etc/puppet/modules /etc/puppet/manifests/base.pp ; \
    yum clean all ; rm -rf /tmp/* ; rm -rf /var/cache/* ; rm -rf /var/tmp/* ; rm -rf /var/opt/staging

COPY setenv.sh ${JIRA_INSTALLDIR}/atlassian-jira-software-${JIRA_VERSION}-standalone/bin/
RUN chmod +x ${JIRA_INSTALLDIR}/atlassian-jira-software-${JIRA_VERSION}-standalone/bin/setenv.sh

# Ports Jira web interface
EXPOSE 8080/tcp

WORKDIR $FACTER_JIRA_INSTALLDIR

# Configurations folder, install dir
VOLUME  $JIRA_HOME

#CMD /opt/puppetlabs/puppet/bin/puppet apply -l /tmp/puppet.log  --modulepath=/etc/puppet/modules /etc/puppet/manifests/start.pp
CMD ["start-service"]
