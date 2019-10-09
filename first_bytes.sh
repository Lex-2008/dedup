#!/bin/busybox ash

# Fills database with files

test -z "$DB"  && DB=dedup.db
test -z "$BS"  && BS=512

SQLITE="sqlite3 $DB"

$SQLITE "ALTER TABLE main ADD COLUMN checksum TEXT;"

cmd="	echo '.timeout 10000'
	echo 'BEGIN TRANSACTION;'
	while test \$# -ge 1; do
		inode=\"\${1%%|*}\"
		filename=\"\${1##*|}\"
		echo \"UPDATE main SET checksum='\$(dd if=\"\$filename\" bs=\"$BS\" count=1 2>/dev/null | sha1sum)' WHERE inode='\$inode';\"
		shift
	done
	echo 'END TRANSACTION;'
	echo 'PRAGMA optimize;'"

$SQLITE "SELECT inode, filename FROM main;" | tr '\n' '\0' | xargs -0 sh -c "$cmd" x | $SQLITE