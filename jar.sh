#!/bin/sh
java -cp classes ifn.tools.ManifestGenerator
/bin/rm -f ifn.jar
jar cfm ifn.jar resource/ifn.manifest.mf -C classes . || exit 1
/bin/rm -f winservice.jar
jar cfm winservice.jar resource/winservice.manifest.mf -C classes . || exit 1

echo "jar files generated successfully"
