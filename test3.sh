#!/bin/busybox ash

# Some test
mkdir -p test

echo a>test/a
echo a>test/b
ln test/a test/aa
ln test/b test/bb

tree --inodes test/

export MIN=0c
export BS=1
echo ...First, init the database
./init.sh

echo ...Now, search for files
./search.sh test

echo ...Now, checksum them
./checksum.sh
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh

tree --inodes test/

rm -rf test
