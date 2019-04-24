package {'sudo':
  ensure => present
}->
package{'zip':
  ensure => present
}

package{'dos2unix':
  ensure => present
}

file{ '/etc/yum.repos.d/epel.repo':
  ensure => present,
  content => '[epel]
name=Extra Packages for Enterprise Linux 7 - $basearch
#baseurl=http://download.fedoraproject.org/pub/epel/7/$basearch
mirrorlist=https://mirrors.fedoraproject.org/metalink?repo=epel-7&arch=$basearch
failovermethod=priority
enabled=1
gpgcheck=0'
}

#https://download.oracle.com/otn/java/jdk/8u212-b10/59066701cf1a433da9770636fbc4c9aa/jre-8u212-linux-x64.tar.gz
#java-1.8.0-openjdk-1.8.0.212.b04-0.el7_6
#java-11-openjdk-11.0.3.7-0.el7_6


if $java_version == '11'
{
  $java_package = "java-${java_version}-openjdk-${java_version}.0.${java_version_update}.${java_version_build}-0.el7_6"
}
else
{
  $java_package = "java-1.${java_version}.0-openjdk-1.${java_version}.0.${java_version_update}.b${java_version_build}-0.el7_6"
}

class { 'java':
  package  => $java_package,
}

# java::oracle { 'jre8' :
  # ensure  => 'present',
  # version_major => "${java_version}u${java_version_update}",
  # version_minor => "b${java_version_build}",
  # java_se => 'server-jre',
  # oracle_url => 'http://download.oracle.com/otn/java/jdk',
  # url_hash => $java_version_hash,
# }

-> file { '/etc/pki/tls/certs/java':
  ensure  => directory
}

-> file { '/etc/pki/tls/certs/java/cacerts':
  ensure  => link,
  target  => '/etc/pki/ca-trust/extracted/java/cacerts'
}

-> file { "/usr/lib/jvm/jre/lib/security/cacerts":
  ensure  => link,
  target  => '/etc/pki/tls/certs/java/cacerts'
}

-> file { '/opt/java_home/':
  ensure  => directory
}

-> file { '/opt/java_home/java_home':
  ensure  => link,
  target  => '/usr/lib/jvm'
}
  
-> class { 'jira':
  javahome       => $java_home,
  version        => $jira_version,
  checksum       => $jira_checksum,
  installdir     => $jira_installdir,
  homedir        => $jira_home,
  service_manage => false
}

-> file {'/opt/jira-config':
  ensure  => directory,
  source  => "file:///${jira_installdir}/atlassian-jira-software-${jira_version}-standalone/conf",
  recurse => 'true'
} ->

file {'/opt/scripts/fixline.sh':
  mode    => '0777',
  content => 'find . -iname \'*.sh\' | xargs dos2unix',
  require => Package['dos2unix']
} ->

# Fix dos2unix
exec {'dos2unix-fix':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  cwd     => "${jira_installdir}/atlassian-jira-software-${jira_version}-standalone/bin",
  command => '/opt/scripts/fixline.sh'
} ->

exec {'dos2unix-fix-start-service':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  cwd     => "/opt/scripts",
  command => '/opt/scripts/fixline.sh'
} ->

file { '/usr/bin/start-service':
  ensure => link,
  target => '/opt/scripts/start-service.sh',
}

exec {'erase dbconfig':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "rm -f ${jira_home}/dbconfig.xml"
} ->

# Full update
exec {'Full update':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'yum -y update'
} ->
# Cleaning unused packages to decrease image size
exec {'erase installer':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /tmp/*; rm -rf /opt/staging/*'
} ->

exec {'erase cache':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/cache/*'
} ->
exec {'erase logs':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => 'rm -rf /var/log/*'
}


package {'openssh': ensure => absent }
package {'openssh-clients': ensure => absent }
package {'openssh-server': ensure => absent }
package {'rhn-check': ensure => absent }
package {'rhn-client-tools': ensure => absent }
package {'rhn-setup': ensure => absent }
package {'rhnlib': ensure => absent }

package {'/usr/share/kde4':
  ensure => absent
}
