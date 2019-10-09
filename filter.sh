#!/bin/busybox ash

# Fills database with files

test -z "$DB"  && DB=dedup.db

SQLITE="sqlite3 $DB"

echo -n "rows before: "
$SQLITE "SELECT count(*) FROM main;"

columns="$($SQLITE "SELECT name FROM pragma_table_info('main') WHERE name NOT IN ('inode', 'filename');" | tr '\n' ',' | head -c-1)"
echo "filtering on [$columns]"

$SQLITE "DELETE FROM main WHERE inode IN (
		SELECT inode FROM main GROUP BY $columns HAVING count(*)=1
	);"

echo -n "rows after: "
$SQLITE "SELECT count(*) FROM main;"
