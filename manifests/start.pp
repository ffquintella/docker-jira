
$real_appdir = "${jira_installdir}/atlassian-jira-software-${jira_version}-standalone"

/*class { 'jira':
  javahome       => $java_home,
  version        => $jira_version,
  installdir     => $jira_installdir,
  homedir        => $jira_home,
  service_manage => false
} ->
*/

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
}

$packs = split($extra_packs, ";")

$packs.each |String $value| {
  package{$value:
    ensure => present
  }
}

if $pre_run_cmd != '' {
  $real_pre_run_cmd = $pre_run_cmd
} else {
  $real_pre_run_cmd = "echo 0;"
}

# Using Pre-run CMD
exec {'Pre Run CMD':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => $real_pre_run_cmd
} ->
# Starting bamboo
exec {'Starting Jira':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Starting Jira Server ...\"; $real_appdir/bin/start-jira.sh & ",
  require => Exec['dos2unix-fix-start-service']
}
