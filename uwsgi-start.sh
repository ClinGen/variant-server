#!/bin/bash -ex

# It is expected this script will be executed as root. It's final step is
# to start the uwsgi gateway and to do so it will drop privilege to the
# variant-server user and www-data group. It needs root however if it
# needs to perform the chores of starting nginx and mongod. Those could
# have already been done by an upstream script that calls this one.

# Start nginx if it is not yet started by something else
# Someone out there - I would love to know if there is a simpler more direct
# way of checking if a program is running. This works though.
if [ -z "`ps ax | grep -e nginx | grep -v grep 2> /dev/null`" ]; then
    /etc/init.d/nginx start
fi

# Start mongod if it is not yet started by something else
if [ -z "`ps ax | grep -e mongod | grep -v grep 2> /dev/null`" ]; then
    mongod --fork -f /etc/mongod.conf
fi

echo Starting uWSGI gateway...
cd /home/variant-server
sudo -u variant-server -g www-data uwsgi --ini variant-server-uwsgi.ini