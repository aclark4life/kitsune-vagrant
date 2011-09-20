group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet. Featuring kitsune.\n"
}

exec { "apt_update":
    command => "sudo aptitude update",
    path => "/usr/bin",
}

exec { "apt_upgrade":
    command => "sudo aptitude -y safe-upgrade",
    path => "/usr/bin",
}

exec { "install_git":
    command => "sudo aptitude -y install git-core",
    path => "/usr/bin",
}

exec { "install_python":
    command => "sudo aptitude -y install python2.6;
                sudo aptitude -y install python2.6-dev",
    path => "/usr/bin",
}

exec { "clone_kitsune":
    command => "git clone git://github.com/aclark4life/kitsune.git",
    # command => "git clone --recursive git://github.com/jsocol/kitsune.git",
    path => "/usr/bin",
}
