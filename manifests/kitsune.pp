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

$packages = [
    "git-core",
    "libmysqlclient-dev",
    "libxml2-dev",
    "libxslt-dev",
    "mysql-server",
    "python-pip",
    "python2.6",
    "python2.6-dev",
    "python-distribute",
    "sphinxsearch",
]

package {
    $packages: ensure => "installed",
    require => Exec['upgrade'],
}

exec { "update":
    command => "aptitude update",
    logoutput => "true",
    path => "/usr/bin",
}

exec { "upgrade":
    command => "aptitude -y upgrade",
    path => "/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin",
    logoutput => "true",
    require => Exec['update'],
}

exec { "git_clone":
    command => "git clone --recursive git://github.com/aclark4life/kitsune.git",
    cwd => "/home/vagrant",
    logoutput => "true",
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
    logoutput => "true",
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

exec { "db_create":
    command => "mysqladmin -u root create kitsune;",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['vendor_packages'],
}

exec { "db_import":
    command => "mysql -u root kitsune < scripts/schema.sql;",
    cwd => "/home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['db_create'],
}

exec { "db_sync":
    command => "manage.py syncdb",
    cwd => "/home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin:/bin:home/vagrant/kitsune",
    require => Exec['db_import'],
}
