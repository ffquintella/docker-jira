
$real_appdir = "${jira_installdir}/atlassian-jira-software-${jira_version}-standalone"

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
exec {'Coping Configs':
  path    => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Coping configs ...\"; cp -r /opt/jira-config/* ${real_appdir}/conf; chown -R jira:jira ${real_appdir}/conf ",
  creates => "${real_appdir}/conf/server.xml"
} ->
# Starting jira
exec {'Starting Jira':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "${real_appdir}/bin/start-jira.sh"
}
