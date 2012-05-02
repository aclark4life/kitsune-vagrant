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

file { '/etc/supervisor/supervisord.conf':
    content => "
[unix_http_server]
file=/var/run//supervisor.sock   ; (the path to the socket file)
chmod=0700                       ; sockef file mode (default 0700)

[supervisord]
logfile=/var/log/supervisor/supervisord.log ; (main log file;default $CWD/supervisord.log)
pidfile=/var/run/supervisord.pid ; (supervisord pidfile;default supervisord.pid)
childlogdir=/var/log/supervisor            ; ('AUTO' child log dir, default $TEMP)

[rpcinterface:supervisor]
supervisor.rpcinterface_factory = supervisor.rpcinterface:make_main_rpcinterface

[supervisorctl]
serverurl=unix:///var/run//supervisor.sock ; use a unix:// URL  for a unix socket

[program:kitsune]
command = /home/vagrant/kitsune/manage.py runserver 33.33.33.10:8000
directory = /home/vagrant/kitsune
user = vagrant
",
}

$packages_native = [
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
    "supervisor",
]

package {
    $packages_native: ensure => "installed",
    require => Exec['packages_upgrade'],
}

exec { "packages_update":
    command => "aptitude update",
    logoutput => "true",
    path => "/usr/bin",
}

exec { "packages_upgrade":
    command => "aptitude -y upgrade",
    path => "/bin:/sbin:/usr/bin:/usr/local/sbin:/usr/sbin",
    logoutput => "true",
    require => Exec['packages_update'],
    timeout => "6000",
}

exec { "git_clone":
    command => "git clone --recursive git://github.com/aclark4life/kitsune.git",
    cwd => "/home/vagrant",
    logoutput => "true",
    path => "/usr/bin",
    require => Package[$packages_native],
}

exec { "chown_kitsune":
    command => "sudo chown -R vagrant:vagrant /home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin",
    require => Exec['git_clone'],
}

exec { "packages_compiled":
    command => "sudo pip install -r requirements/compiled.txt",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin",
    require => Exec['chown_kitsune'],
}

exec { "packages_vendor":
    command => "git submodule update --init --recursive",
    cwd => "/home/vagrant/kitsune",
    path => "/usr/bin:/bin",
    logoutput => true,
    require => Exec[
        'packages_compiled',
        'chown_kitsune',
        'git_clone'
    ],
    timeout => "6000",
}

exec { "db_create":
    command => "mysqladmin -u root create kitsune;",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['packages_vendor'],
}

exec { "db_import":
    command => "mysql -u root kitsune < scripts/schema.sql;",
    cwd => "/home/vagrant/kitsune",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['db_create'],
}

exec { "supervisor_stop":
    command => "/etc/init.d/supervisor stop",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => File['/etc/supervisor/supervisord.conf'],
}

exec { "supervisor_start":
    command => "/etc/init.d/supervisor start",
    logoutput => "true",
    path => "/usr/bin:/bin",
    require => Exec['supervisor_stop'],
}
