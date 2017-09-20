#!/bin/sh
if [ -e ~/.ifn/ifn.pid ]; then
    PID=`cat ~/.ifn/ifn.pid`
    ps -p $PID > /dev/null
    STATUS=$?
    echo "stopping"
    while [ $STATUS -eq 0 ]; do
        kill `cat ~/.ifn/ifn.pid` > /dev/null
        sleep 5
        ps -p $PID > /dev/null
        STATUS=$?
    done
    rm -f ~/.ifn/ifn.pid
    echo "Ifn server stopped"
fi

