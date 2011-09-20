group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet. Featuring kitsune.\n"
}

exec { "update":
    command => "sudo aptitude update",
    path => "/usr/bin",
}

exec { "upgrade":
    command => "sudo aptitude -y safe-upgrade",
    path => "/usr/bin",
}
