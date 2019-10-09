#!/bin/busybox ash

# Fills database with files

test -z "$DB"  && DB=dedup.db
test -z "$BS"  && BS=512

SQLITE="sqlite3 $DB"

case "$1" in
	(first)
		checksum_cmd="dd if=\"\$filename\" bs=\"$BS\" count=1 2>/dev/null | sha1sum"
		;;
	(last)
		offset_calc="\$size $BS / 0.1 - 0 or p"
		checksum_cmd="dd if=\"\$filename\" bs=\"$BS\" count=1 skip=\"\$offset\" 2>/dev/null | sha1sum"
		;;
	(middle)
		offset_calc="\$size $BS / 2 / 0 or p"
		checksum_cmd="dd if=\"\$filename\" bs=\"$BS\" count=1 skip=\"\$offset\" 2>/dev/null | sha1sum"
		;;
	(*)
		checksum_cmd="sha1sum \"\$filename\" | head -c 40"
		;;
esac

$SQLITE "ALTER TABLE main ADD COLUMN checksum TEXT;"

if ! test -z "$offset_calc"; then
	size_cmd="size=\"\${1##*|}\"
		filename=\"\${filename%|*}\"
		offset=\"\$(echo \"$offset_calc\" | dc)\""
	select_size=",size"
fi

cmd="	echo '.timeout 10000'
	echo 'BEGIN TRANSACTION;'
	while test \$# -ge 1; do
		inode=\"\${1%%|*}\"
		filename=\"\${1#*|}\"
		$size_cmd
		echo \"UPDATE main SET checksum='\$($checksum_cmd)' WHERE inode='\$inode';\"
		shift
	done
	echo 'END TRANSACTION;'
	echo 'PRAGMA optimize;'"

$SQLITE "SELECT inode, filename $select_size FROM main;" | tr '\n' '\0' | xargs -0 sh -c "$cmd" x | $SQLITE
