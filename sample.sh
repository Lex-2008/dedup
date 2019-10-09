#!/bin/busybox ash

echo ...First, init the database
./init.sh

echo ...Now, search for files
./search.sh "$@"
echo ...And filter files based on sizes
./filter.sh

echo ...Now, filter files based on first bytes
./first_bytes.sh
./filter.sh

echo ...Now, filter files based on last bytes
./last_bytes.sh
./filter.sh

echo ...Now, filter files based on middle bytes
./middle_bytes.sh
./filter.sh

echo ...Now, filter files based on checksums
./checksum.sh
./filter.sh

echo ...Now, hardlink similar files
./hardlink.sh
