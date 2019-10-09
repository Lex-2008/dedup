#!/bin/busybox ash

# Some test
mkdir -p test/dir

echo a>test/a
echo b>test/b
echo c>test/c
echo d>test/d
echo zzz>test/zzz

echo a>test/dir/aa
echo d>test/dir/dd
echo d>test/dd
ln test/b test/dir/b

tree --inodes test/

export MIN=0c
echo ...First, init the database
./init.sh

echo ...Now, search for files
./search.sh test
echo ...And filter files based on sizes
./filter.sh

echo ...Now, filter files based on checksums
./checksum.sh
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh

tree --inodes test/

rm -rf test
