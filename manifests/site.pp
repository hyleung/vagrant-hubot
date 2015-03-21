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
}

