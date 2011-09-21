group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
  content => "Welcome to your Vagrant-built virtual machine!
              Managed by Puppet. Featuring kitsune.\n"
}

#exec { "update":
#    command => "sudo aptitude update",
#    path => "/usr/bin",
#}
#
#exec { "upgrade":
#    command => "sudo aptitude -y safe-upgrade",
#    path => "/usr/bin",
#}

package { "git-core": ensure => "installed" }
package { "libmysqlclient-dev": ensure => "installed" }
package { "libxml2-dev": ensure => "installed" }
package { "libxslt-dev": ensure => "installed" }
package { "mysql-server": ensure => "installed" }
package { "python-pip": ensure => "installed" }
package { "python2.6": ensure => "installed" }
package { "python2.6-dev": ensure => "installed" }
package { "python-distribute": ensure => "installed" }
package { "sphinxsearch": ensure => "installed" }

exec { "git_clone":
    command => "git clone --recursive git://github.com/aclark4life/kitsune.git",
    cwd => "/home/vagrant",
    logoutput => "on_failure",
    path => "/usr/bin",
    require => package['git-core'],
    require => package['libmysql-client-dev'],
    require => package['libxml2-dev'],
    require => package['libxslt-dev'],
    require => package['mysql-server'],
    require => package['python-pip'],
    require => package['python2.6'],
    require => package['python2.6-dev'],
    require => package['python-distribute'],
    require => package['sphinxsearch'],
}

exec { "chown_kitsune":
    command => "sudo chown -R vagrant:vagrant /home/vagrant/kitsune",
    logoutput => "on_failure",
    path => "/usr/bin",
    require => Exec['git_clone'],
}

exec { "compiled_packages":
    command => "sudo pip install -r requirements/compiled.txt",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin",
    require => Exec['chown_kitsune'],
}

exec { "vendor_packages":
    command => "git submodule update --init --recursive",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin",
    require => Exec['compiled_packages'],
}
