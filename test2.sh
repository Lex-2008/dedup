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

echo ...Now, filter files based on first bytes
./first_bytes.sh
./filter.sh

echo ...Now, filter files based on middle bytes
./middle_bytes.sh
./filter.sh

echo ...Now, filter files based on last bytes
./last_bytes.sh
./filter.sh

echo ...Now, filter files based on checksums
./checksum.sh
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh

tree --inodes test/

rm -rf test
