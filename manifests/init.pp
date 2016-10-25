class livepatch($ensure='disabled', $token=undef) {

  $lp_bin = '/snap/bin/canonical-livepatch'
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
