#!/bin/bash

fname="serialized-nop"
N=1
# Increment $N as long as a directory with that name exists
while [[ -d "/home/anmol-backup/MLP/$fname-$N" ]] ; do
    N=$(($N+1))
done

mkdir "/home/anmol-backup/MLP/$fname-$N"
cp -r ./* /home/anmol-backup/MLP/$fname-$N/
