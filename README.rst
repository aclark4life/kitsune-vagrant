
Introduction
============

Clone this repository to run a kitsune [1]_ development environment inside a virtual machine [2]_::

    $ git clone git://github.com/aclark4life/kitsune-vagrant.git 
    $ cd kitsune-vagrant
    $ vagrant box add kitsune http://files.vagrantup.com/lucid64.box [3]_
    $ vagrant up

Open http://33.33.33.10 in your browser (which of course, is `Firefox`_).

.. [1] https://github.com/jsocol/kitsune
.. [2] Requires vagrant and VirtualBox to be installed: http://vagrantup.com, http://www.virtualbox.org/.
.. _`Firefox`: http://getfirefox.com
.. [3] You only need to do this once. Afterward you can ``vagrant destroy`` and ``vagrant up`` as needed.
