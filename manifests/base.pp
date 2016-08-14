package {'sudo':
  ensure => present
}
package{'zip':
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

class { 'jdk_oracle':
  version     => '8',
  install_dir => $java_home,
  package     => 'server-jre'
} ->

class { 'jira':
  javahome      => $java_home,
  version       => $jira_version,
  installdir    => $jira_installdir,
  homedir       => $jira_home,
  download_url  =>'https://downloads.atlassian.com/software/jira/downloads/binary/'
}
class { 'jira::facts': }

/*->
if $bamboo_proxy  != 'false' {
class { 'bamboo':
  version      => $bamboo_version,
  installdir   => $bamboo_installdir,
  homedir      => $bamboo_home,
  java_home    => $java_home,
  download_url => $bamboo_dowload_url,
  context_path => $bamboo_context,
  proxy        => {
    scheme    => $bamboo_proxy_scheme,
    proxyName => $bamboo_proxy_name,
    proxyPort => $bamboo_proxy_port,
  },
}
} else {
  class { 'bamboo':
    version      => $bamboo_version,
    installdir   => $bamboo_installdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    download_url => $bamboo_dowload_url,
    context_path => $bamboo_context
  }
}
*/

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
