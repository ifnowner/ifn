#!/bin/sh
if [ -e ~/.ifn/ifn.pid ]; then
    PID=`cat ~/.ifn/ifn.pid`
    ps -p $PID > /dev/null
    STATUS=$?
    if [ $STATUS -eq 0 ]; then
        echo "Ifn server already running"
        exit 1
    fi
fi
mkdir -p ~/.ifn/
DIR=`dirname "$0"`
cd "${DIR}"
if [ -x jre/bin/java ]; then
    JAVA=./jre/bin/java
else
    JAVA=java
fi
nohup ${JAVA} -cp classes:lib/*:conf:addons/classes:addons/lib/* -Dwin.runtime.mode=desktop ifn.Ifn > /dev/null 2>&1 &
echo $! > ~/.ifn/ifn.pid
cd - > /dev/null
