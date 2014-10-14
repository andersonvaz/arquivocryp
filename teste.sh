#!/bin/bash
if [ "$(id -u)" != "0" ]; then
	echo "Execute o comando com sudo";
	exit 1
fi
arq="teste";
arqdir="DISCO/$arq.img";
destino="/mnt";
lock="$arqdir.lck";

if [ -f $lock ]; then
 echo "Desmontando disco:$arq";
 umount $destino
 cryptsetup luksClose $arq;
 nomeloop=$(cat $lock);
 losetup -d $nomeloop
 rm $lock;
else
 echo "Montando disco:$arq";
 nomeloop=$(losetup -f);
 losetup $nomeloop $arqdir
 cryptsetup luksOpen $nomeloop $arq
 mount -t ext4 -o rw,defaults /dev/mapper/$arq $destino
 echo $nomeloop > $lock;
fi;
