#!/bin/bash

#sudo chmod a+x /home/ifn/update_server_param.sh

#clear
#service ifn-server stop > /dev/null 2>&1 &
echo "Stop IFN server"

#/etc/init.d/ifn-server stop > /dev/null 2>&1 &
/etc/init.d/ifn-server stop
#echo "wait 5 secs..."
#sleep 5
#cd /home/ifn
#rm -rf ifn_db

myAddress=`ifconfig eth0 2>/dev/null|awk '/inet / {print $2}'|sed 's/addr://'`;
echo 'myAddress='$myAddress
#myInternalAddress=`ifconfig eth0:1 2>/dev/null|awk '/inet / {print $2}'|sed 's/addr://'`;
#echo 'myInternalAddress='$myInternalAddress

myPlatformDefault='Node-'$myAddress
homeDirDefault=/home/ifn
reductorFeeDefault=100

#echo "Type the home dir ($homeDirDefault):"
#read homeDir
if [ -z "$homeDir" ]; then
	homeDir=$homeDirDefault
fi
echo "Home dir is $homeDir"
#echo "Type the platform name to be announced to peers ($myPlatformDefault):"
#read myPlatform
#if [ -z "$myPlatform" ]; then
#	myPlatform=$myPlatformDefault
#fi
#echo "Type the value of reductorFee ($reductorFeeDefault):"
#read reductorFee
if [ -z "$reductorFee" ]; then
	reductorFee=$reductorFeeDefault
fi
#echo "Type the server HALLMARK:"
#read myHallmark
if [ -z "$reductorFee" ]; then
	reductorFee=1
fi
echo "reductorFee is $reductorFee"
#echo "Type the forger secret phrase:"
#read forgerSecretPhrase
#forgerSecretPhrase=$(sed 's/[\/&]/\\&/g' <<<"$forgerSecretPhrase")
#echo $forgerSecretPhrase

case $myAddress in
    139.162.27.125|172.104.121.231|172.104.131.138|139.162.202.179|66.175.222.34)
          PEERNODE=(139.162.27.125 172.104.121.231 172.104.131.138 139.162.202.179 66.175.222.34)
          ;;
     *)
          echo 'Undefined myAddress '$myAdress
          exit
          ;;
esac

file=conf/ifn-default.properties.base
file_new=conf/ifn-default.properties
peerServerPort=27874
apiServerPort=27876
apiServerSSLPort=27876
adminPassword=tantoVaLagatta$myAddress
currencyName=IFN
uiServerPort=27875
disabledAPITags='Aliases;Digital Goods Store;Monetary System;Debug;Add-ons;'
#ACCOUNTS("Accounts"), ACCOUNT_CONTROL("Account Control"), ALIASES("Aliases"), AE("Asset Exchange"), BLOCKS("Blocks"),
#CREATE_TRANSACTION("Create Transaction"), DGS("Digital Goods Store"), FORGING("Forging"), MESSAGES("Messages"),
#MS("Monetary System"), NETWORK("Networking"), PHASING("Phasing"), SEARCH("Search"), INFO("Server Info"),
#SHUFFLING("Shuffling"), DATA("Tagged Data"), TOKENS("Tokens"), TRANSACTIONS("Transactions"), VS("Voting System"),
#UTILS("Utils"), DEBUG("Debug"), ADDONS("Add-ons");

for PEER in "${PEERNODE[@]}"
do
	if [ $PEER != $myAddress ] ; then
		wellKnownPeers=$wellKnownPeers$PEER'; '
	fi
done
for PEER in "${PEERNODEBLACKLIST[@]}"
do
	if [ $PEER != $myAddress ] ; then
		knownBlacklistedPeers=$knownBlacklistedPeers$PEER'; '
	fi
done

enableApiTestUI=false
enableAPIServer=true
maxPrunableLifetime=7776000
case $myAddress in
     139.162.27.125)
          forgerSecretPhrase='2c40f677bbf43e3a0c9956925762c00244734dd1ecb0457ab222b07379a7bbd25fb5efb503edc2c0b8abd676caa41874df2b4e54c956a6be4e5df693a473debf'
          myHallmark=''
          #myDomain=$myAddress
          myDomain=192.168.143.78
          maxPrunableLifetime=-1
          ;;
     172.104.121.231)
          forgerSecretPhrase='a63165ad242b9a42f1c740340276a0889b1de1803687df3e44d0d68979aeb1fcbe2fc24ce998f913d2fe1fc6de317846abf88c60cc823e58b85b153472e80df4'
          myHallmark=''
          #myDomain=$myAddress
          myDomain=192.168.138.152
          ;;
     172.104.131.138)
          forgerSecretPhrase='e623b43713c1ba2978ed103fb6876a0c9a272353f2041c285154bb3d8b2671d8d614fb7ca74b4c9c36472b8869dd6f49dd1768b1d9f544eea8de4325f7657b7d'
          myHallmark=''
          #myDomain=$myAddress
          myDomain=192.168.148.89
          maxPrunableLifetime=-1
          ;;
     139.162.202.179)
          forgerSecretPhrase='e67bed88979eb5fab0ebdcf2dd2b09a89b4f6780a3f8e6bbb986aa048b3300b808e55bd0bb3209af755b4bd2d7c33ace3e804713e778e406099f552a0e01d794'
          myHallmark=''
          #myDomain=$myAddress
          myDomain=192.168.159.24
          ;;
     66.175.222.34)
          forgerSecretPhrase='f40d0a097d16ebc3aaafc0b29206b0c94cb07214bac6112f1aa28ab90b0b602e66d6532bb98b1745351cbbb5ba953ec69810be867f3dbfb721390bad3c0f141a'
          myHallmark=''
          #enableAPIServer=false
          myDomain=$myAddress
          ;;
     *)
          forgerSecretPhrase=''
          myHallmark=''
          myDomain=$myAddress
          ;;
esac
myDomain=$myAddress

myPlatform='Node-'$myDomain
echo "myDomain is $myDomain"
echo "myPlatform is $myPlatform"
echo "wellKnownPeers is $wellKnownPeers"

forgerSecretPhrase=$(sed 's/[\/&]/\\&/g' <<<"$forgerSecretPhrase")
echo 'Found forgerSecretPhrase='$forgerSecretPhrase

if [[ -f $homeDir/$file ]] && [[ -w $homeDir/$file ]]; then
	rm -rf $homeDir/$file_new
	rm -rf $homeDir/ifn.properties
	cp $homeDir/$file $homeDir/$file_new
	sed -i -- "s/ifn.myAddress=/ifn.myAddress=$myDomain/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.myPlatform=/ifn.myPlatform=$myPlatform/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.myHallmark=/ifn.myHallmark=$myHallmark/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.wellKnownPeers=/ifn.wellKnownPeers=$wellKnownPeers/g" "$homeDir/$file_new"
	#sed -i -- "s/ifn.defaultPeers=/ifn.defaultPeers=$wellKnownPeers/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.knownBlacklistedPeers=/ifn.knownBlacklistedPeers=$knownBlacklistedPeers/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.forgerSecretPhrase=/ifn.forgerSecretPhrase=$forgerSecretPhrase/g" "$homeDir/$file_new"
	#echo $forgerSecretPhrase   sed -i -- "s/ifn.forgerSecretPhrase=/ifn.forgerSecretPhrase=\1/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.reductorFee=/ifn.reductorFee=$reductorFee/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.peerServerPort=/ifn.peerServerPort=$peerServerPort/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.apiServerPort=/ifn.apiServerPort=$apiServerPort/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.apiServerSSLPort=/ifn.apiServerSSLPort=$apiServerSSLPort/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.adminPassword=/ifn.adminPassword=$adminPassword/g" "$homeDir/$file_new"
	#sed -i -- "s/ifn.currencyName=/ifn.currencyName=$currencyName/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.uiServerPort=/ifn.uiServerPort=$uiServerPort/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.disabledAPITags=/ifn.disabledAPITags=$disabledAPITags/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.maxPrunableLifetime=/ifn.maxPrunableLifetime=$maxPrunableLifetime/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.enableApiTestUI=/ifn.enableApiTestUI=$enableApiTestUI/g" "$homeDir/$file_new"
	sed -i -- "s/ifn.enableAPIServer=/ifn.enableAPIServer=$enableAPIServer/g" "$homeDir/$file_new"



fi

#######################################################
#               ONLY FIRST TIME                       #
#echo 'rm -rf /home/ifn/ifn_db_old'
#rm -rf /home/ifn/ifn_db_old
#echo 'mv /home/ifn/ifn_db /home/ifn/ifn_db_old'
#mv /home/ifn/ifn_db /home/ifn/ifn_db_old
#######################################################
echo 'rm -rf  $homeDir/src/java/ifndesktop.old'
rm -rf  $homeDir//src/java/ifndesktop.old
echo 'mv  $homeDir/src/java/ifndesktop  $homeDir/src/java/ifndesktop.old'
mv  $homeDir/src/java/ifndesktop  $homeDir/src/java/ifndesktop.old
echo 'rm -rf  $homeDir/jre-old'
rm -rf  $homeDir/jre-old
echo 'mv  $homeDir/jre  $homeDir/jre-old'
mv  $homeDir/jre  $homeDir/jre-old

#case $myAddress in
#     172.104.36.203)
#			echo 'remove html/www e wtml/nrs folder'
#			rm -rf  $homeDir/html/www
#			rm -rf  $homeDir/html/nrs
#          ;;
#     *)
#          echo 'No delete required'
#          ;;
#esac

echo "Recompile IFN server"
#/home/ifn/compile.sh > /dev/null
#/home/ifn/compile.sh > /dev/null 2>&1 &
$homeDir/compile.sh
#echo "wait almost 30 secs..."
#sleep 30
#echo "Finished compiling"
echo "Restart IFN server"
#######################################################
#          ONLY FIRST TIME DOUBLE RESTART             #
#/etc/init.d/ifn-server restart > /dev/null 2>&1
#######################################################
/etc/init.d/ifn-server restart > /dev/null 2>&1 &
#service ifn-server restart > /dev/null 2>&1 &
echo "End script"

