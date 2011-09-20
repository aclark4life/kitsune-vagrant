group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet. Featuring kitsune.\n"
}

exec { "updates":
    command => "sudo aptitude update;
                sudo aptitude -y safe-upgrade",
    path => "/usr/bin",
}

package { "git-core": ensure => "installed" }
package { "libmysqlclient-dev": ensure => "installed" }
package { "mysql-server":   ensure => "installed" }
package { "python2.6":   ensure => "installed" }
package { "python2.6-dev":   ensure => "installed" }
package { "python-distribute":   ensure => "installed" }

exec { "the_rest":
    command => "sudo easy_install-2.6 pip;
                cd /home/vagrant;
                git clone --recursive git://github.com/aclark4life/kitsune.git;
                sudo chown -R vagrant:vagrant /home/vagrant/kitsune;
                cd /home/vagrant/kitsune;
                sudo pip install -r requirements/compiled.txt;
                git submodule update --init --recursive;",
    path => "/usr/bin",
}
