
Introduction
============

Follow these steps to run a kitsune [1]_ development environment inside a virtual machine [2]_

Installation
============

Clone the repository::

    $ git clone git://github.com/aclark4life/kitsune-vagrant.git 
    $ cd kitsune-vagrant

Then add a vagrant box [3]_::

    $ vagrant box add kitsune http://files.vagrantup.com/lucid64.box

Then up the vagrant box::

    $ vagrant up

This will take about 15-20 minutes to run on a "modern" machine (author has 2.66Ghz Macbook Pro w/4GB RAM). When it finishes, you should be able to open:

- http://33.33.33.10:8000

Eventually, you will be able to see kitsune running by opening http://33.33.33.10 in your browser (via mod_wsgi).

Todo
====

- Use https://github.com/jsocol/kitsune-vagrant instead of https://github.com/aclark4life/kitsune-vagrant.
    - XXX?
- Add mod_wsgi support.

Troubleshooting
===============

Vagrant is taking too long
--------------------------

Sometimes ``vagrant up`` will say::

    [default] Waiting for VM to boot. This can take a few minutes.

then take much longer. If it takes longer than a few minutes, CTRL-C and re-run ``vagrant up``.

Vagrant says read-only fs
-------------------------

Sometimes ``vagrant up`` will quit with the message::

    [default] err: Could not send report: Got 1 failure(s) while initializing: change from absent to directory failed: Could not set 'directory on ensure: Read-only file system - /var/lib/puppet/rrd

``vagrant destroy`` and ``vagrant up`` again should fix the problem (whatever it is).

.. [1] https://github.com/jsocol/kitsune
.. [2] Requires vagrant and VirtualBox to be installed: http://vagrantup.com, http://www.virtualbox.org/.
.. _`Firefox`: http://getfirefox.com
.. [3] You only need to do this once. Afterward you can ``vagrant destroy`` and ``vagrant up`` as needed.

