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
  package { 'zip':
    ensure => present
  }
  package { 'unzip':
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

  class { 'sudo':
    purge               => false,
    config_file_replace => false
  }

  sudo::conf { 'deploy':
      priority => 10,
      content  => '%deploy ALL= NOPASSWD: ALL',
  }

  vcsrepo { '/opt/hubot':
    ensure   => present,
    provider => git,
    source   => hiera('hubot::git_url'),
    owner    => 'hubot',
    group    => 'deploy',
    require  => User['hubot']
  }
  file { '/etc/init/hubot.conf':
    ensure    => file,
    content   => template('/vagrant/files/hubot.conf.erb')
  }
  file { '/home/hubot/update_hubot.sh':
    ensure  => file,
    content => template('/vagrant/files/update_hubot.sh.erb'),
    require => User['hubot']
  }
  file { '/usr/bin/npm':
    ensure  => link,
    target  => '/usr/local/node/node-default/bin/npm',
    require => Class['nodejs']
  }
  file { '/usr/bin/node':
    ensure  => link,
    target  => '/usr/local/node/node-default/bin/node',
    require => Class['nodejs']
  }
  exec { 'npm-update':
    command => '/usr/bin/npm update',
    require => File['/usr/bin/npm']
  }
  service { 'hubot':
    ensure  => running,
    require => [File['/usr/bin/npm', '/usr/bin/node', '/etc/init/hubot.conf']
    , VcsRepo['/opt/hubot']]
  }
}

