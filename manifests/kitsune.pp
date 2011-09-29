group { "puppet":
  ensure => "present",
}

File { owner => 0, group => 0, mode => 0644 }

file { '/etc/motd':
    content => "Welcome to your Vagrant-built virtual machine!
                Managed by Puppet. Featuring kitsune.\n"
}

file { '/home/vagrant/kitsune/settings_local.py':
    content => "from settings import *\n
DATABASES = {
    'default': {
        'NAME': 'kitsune',
        'ENGINE': 'django.db.backends.mysql',
        'HOST': 'localhost',
        'USER': 'root',
        'PASSWORD': '',
        'OPTIONS': {'init_command': 'SET storage_engine=InnoDB'},
        'TEST_CHARSET': 'utf8',
        'TEST_COLLATION': 'utf8_unicode_ci',
    },
}\n",
    require => Exec['git_clone'],
}

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
    require => package[
        'git-core',
        'libmysqlclient-dev',
        'libxml2-dev',
        'libxslt-dev',
        'mysql-server',
        'python-pip',
        'python2.6',
        'python2.6-dev',
        'python-distribute',
        'sphinxsearch'
    ],
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
    path => "/usr/bin:/bin",
    logoutput => true,
    require => Exec[
        'compiled_packages',
        'chown_kitsune',
        'git_clone'
    ],
}
