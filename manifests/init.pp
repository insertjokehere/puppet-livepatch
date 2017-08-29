class livepatch($ensure='disabled', $token=undef) {

  $lp_bin = '/snap/bin/canonical-livepatch'

  ensure_packages(['snapd'], {'ensure' => 'present'})

  # If livepatch is installed before an up-to-date snapd is installed, then livepatch
  # needs to be reinstalled before it will work
  exec { 'remove-old-livepatch':
    command => '/usr/bin/snap remove canonical-livepatch',
    timeout => 0,
    onlyif  => "/usr/bin/file ${lp_bin} && ${lp_bin} status | /bin/grep 'no such file or directory'"
  }
  ->
  exec { 'install-livepatch':
    command => '/usr/bin/snap install canonical-livepatch',
    timeout => 0,
    creates => $lp_bin
  }

  if ($ensure == 'enabled') {
    if ($token == undef) {
      err('Livepatch token must be set before enabling livepatch')
    }
    exec { 'enable-livepatch':
      command => "${lp_bin} enable ${token}",
      onlyif  => "${lp_bin} status | /bin/grep 'Machine is not enabled'",
      require => Exec['install-livepatch']
    }
  }
  elsif ($ensure == 'disabled') {
    exec { 'disable-livepatch':
      command => "${lp_bin} disable",
      unless  => "${lp_bin} status | /bin/grep 'Machine is not enabled'",
      require => Exec['install-livepatch']
    }
  }
}
