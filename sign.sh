#!/bin/sh
java -cp "classes:lib/*:conf" ifn.tools.SignTransactionJSON $@
exit $?
