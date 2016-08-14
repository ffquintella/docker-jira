
class { 'bamboo::params': }


$real_appdir = "${bamboo_installdir}/atlassian-bamboo-${bamboo_version}"

if $bamboo_proxy  != 'false' {
  class { 'bamboo::configure':
    version      => $bamboo_version,
    appdir       => $real_appdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    context_path => $bamboo_context,
    proxy        => {
      scheme    => $bamboo_proxy_scheme,
      proxyName => $bamboo_proxy_name,
      proxyPort => $bamboo_proxy_port,
    },
  }
} else {
  class { 'bamboo::configure':
    version      => $bamboo_version,
    appdir       => $real_appdir,
    homedir      => $bamboo_home,
    java_home    => $java_home,
    context_path => $bamboo_context,
  }
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
exec {'Starting Bamboo':
  path  => '/bin:/sbin:/usr/bin:/usr/sbin',
  command => "echo \"Starting Bamboo Server ...\"; $bamboo_installdir/atlassian-bamboo-$bamboo_version/bin/start-bamboo.sh; "
}
