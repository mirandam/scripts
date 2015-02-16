#!/bin/bash

status=$(/etc/init.d/salt-minion status | sed -e s/'(pid  [0-9]*) '//)

if [[ $status = 'salt-minion dead but pid file exists' ]] || [[ $status = 'salt-minion is stopped' ]] ; then
         sudo /sbin/service salt-minion start
fi

status=$(/etc/init.d/salt-minion status | sed -e s/'(pid  [0-9]*) '//)
if [[ $status = 'salt-minion is running...' ]]; then
        echo "$( date -d now );OK"
else
        echo "$( date -d now );Critical"
fi
