#!/bin/sh
if [ -x jre/bin/java ]; then
    JAVA=./jre/bin/java
else
    JAVA=java
fi
${JAVA} -cp classes:lib/*:conf:addons/classes:addons/lib/* -Dwin.runtime.mode=desktop -Dwin.runtime.dirProvider=ifn.env.DefaultDirProvider ifn.Ifn
