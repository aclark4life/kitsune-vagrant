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

#exec { "apt_upgrade":
#    command => "sudo aptitude -y safe-upgrade",
#    path => "/usr/bin",
#}

exec { "install_kitsune":
    command => "sudo aptitude -y install python2.6;
                sudo aptitude -y install python2.6-dev;
                sudo aptitude -y install git-core;
                cd /home/vagrant;
                git clone --recursive git://github.com/aclark4life/kitsune.git;
                cd /home/vagrant/kitsune;
                sudo easy_install-2.6 pip;
                sudo pip install -r requirements/compiled.txt;",
    path => "/usr/bin",
}
