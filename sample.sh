#!/bin/busybox ash

echo ...First, init the database
./init.sh

echo ...Now, search for files
./search.sh "$@"
echo ...And filter files based on sizes
./filter.sh

echo ...Now, filter files based on first bytes
./checksum.sh first
./filter.sh

echo ...Now, filter files based on last bytes
./checksum.sh last
./filter.sh

echo ...Now, filter files based on middle bytes
./checksum.sh middle
./filter.sh

echo ...Now, filter files based on checksums
./checksum.sh all
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh
