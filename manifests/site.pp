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
  #nodejs
  class { 'nodejs':
    version => 'v0.10.25',
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

  user { 'hubot':
    ensure      => 'present',
    managehome  => true,
    gid         => 'deploy',
    groups      => 'sudo'
  }

  vcsrepo { '/opt/hubot':
    ensure   => present,
    provider => git,
    source   => 'https://github.com/hyleung/my-hubot.git',
    owner    => 'hubot',
    group    => 'deploy',
    require  => User['hubot']
  }

  file { '/etc/init/hubot.conf':
    ensure => file,
    source => '/vagrant/files/hubot.conf'
  }
  exec { 'npm-update':
    command => '/usr/local/node/node-default/bin/npm update',
    require => Class['nodejs']
  }
}

