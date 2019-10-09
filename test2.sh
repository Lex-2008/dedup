#!/bin/busybox ash

# Some test
mkdir -p test

echo -n zzz>test/zzz
echo -n yyy>test/yyy
echo -n zyy>test/zyy
echo -n zzy>test/zzy

tree --inodes test/

export MIN=0c
export BS=1
echo ...First, init the database
./init.sh

echo ...Now, search for files
./search.sh test

echo ...Now, checksum first bytes
./checksum.sh first
./filter.sh

echo ...Now, checksum middle bytes
./checksum.sh middle
./filter.sh

echo ...Now, checksum last bytes
./checksum.sh last
./filter.sh

echo ...Now, checksum whole files
./checksum.sh all
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh

tree --inodes test/

rm -rf test
