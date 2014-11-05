askpass.sh
==========

An akspass script in bash with visual feedback.

Why
---
In general there is no feedback when entering passwords in commandline programs. This can lead to the problem that you enter your password into another application that just got the focus while you were typing. You don't get suspicious because there is no difference between no feedback an typing elsewhere. And then you you've postet your password to a publick chatroom...

Known Issues
------------
- sometimes entering a pasword can't be aborted (at least when used with sudo), ctrl + c doesn't work well, ctrl + d doesn't work very well

Deployment
----------
- I copied the script to a directory owned by root and changed owner and group to root
- sudo, /etc/sudoers:
  - make sudo echo stars when you type the password: `Defaults pwfeedback`
  - specify a default program that is used to read the password: `Defaults askpass = /path/to/askpass.sh`
    - is only used, when sudo is invoked with option -A and can be overwritten by the environment variable SUDO_ASKPASS
  - I use: `alias sudo='SUDO_ASKPASS=/path/to/askpass.sh /usr/bin/sudo -A '`
- encfs:
  - just add the option --extpass=/path/to/askpass.sh
- su doesn't seem to have a similar option :-(
- ssh doesn't provide this option for terminal use :-(

