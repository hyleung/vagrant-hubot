node default {
  class { 'apt':
    update_timeout => undef,
    update_tries   => 3
  }
  #Packages
  package { 'git':
    ensure => present
  }
  package { 'redis-server':
    ensure => present
  }
  #groups/users
  group { 'deploy':
    ensure => present
  }
  user { 'deploy':
    ensure      => present,
    managehome  => true,
    gid         => 'deploy',
    groups      => 'sudo'
  } ->
  ssh_keygen { 'deploy' : }

}

