rem @ECHO OFF
if exist jre ( 
    set javaDir=jre\bin\
)

%javaDir%java.exe -cp classes;lib\*;conf ifn.mint.MintWorker
