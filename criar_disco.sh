#!/bin/bash
tamanho="5000";
nome="teste";
arqdir="DISCO/$nome.img";
dd if=/dev/urandom of=$arqdir bs=1024 count=$tamanho
nomeloop=$(losetup -f);
losetup $nomeloop $arqdir
cryptsetup --verbose --cipher "aes-cbc-essiv:sha256" --key-size 256 --verify-passphrase luksFormat $nomeloop
cryptsetup luksOpen $nomeloop $nome
mkfs.ext4 /dev/mapper/$nome
cryptsetup luksClose $nome
losetup -d $nomeloop
echo "finalizado";
