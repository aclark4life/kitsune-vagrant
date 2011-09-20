group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet. Featuring kitsune.\n"
}

exec { "install_kitsune":
    command => "sudo aptitude update;
                sudo aptitude -y safe-upgrade;
                sudo aptitude -y install
                    git-core
                    libmysqlclient-dev
                    mysql-server
                    python2.6
                    python2.6-dev
                    python-distribute;
                sudo easy_install-2.6 pip;
                cd /home/vagrant;
                git clone --recursive git://github.com/aclark4life/kitsune.git;
                sudo chown -R vagrant:vagrant /home/vagrant/kitsune;
                cd /home/vagrant/kitsune;
                sudo pip install -r requirements/compiled.txt;
                git submodule update --init --recursive;",
    path => "/usr/bin",
}
