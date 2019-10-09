#!/bin/busybox ash

# Fills database with files

test -z "$DB"  && DB=dedup.db

SQLITE="sqlite3 $DB"

$SQLITE "ALTER TABLE main ADD COLUMN checksum TEXT;"

cmd="	echo '.timeout 10000'
	echo 'BEGIN TRANSACTION;'
	while test \$# -ge 1; do
		inode=\"\${1%%|*}\"
		filename=\"\${1#*|}\"
		echo \"UPDATE main SET checksum='\$(sha1sum \"\$filename\" | head -c 40)' WHERE inode='\$inode';\"
		shift
	done
	echo 'END TRANSACTION;'
	echo 'PRAGMA optimize;'"

$SQLITE "SELECT inode, filename FROM main;" | tr '\n' '\0' | xargs -0 sh -c "$cmd" x | $SQLITE
