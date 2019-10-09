#!/bin/busybox ash

# Fills database with files

# Args are dirs to search

test -z "$DB"  && DB=dedup.db
test -z "$MIN" && MIN=1k # min file size (check `man find` for details)


SQLITE="sqlite3 $DB"

/usr/bin/find "$@" -type f -size "+$MIN" -printf '%i %s %p\0' | /bin/sed -r -z "
	1i .timeout 10000
	1i BEGIN TRANSACTION;
	\$a END TRANSACTION;
	s/'/''/g   # duplicate single quotes
	s_^([0-9]*) ([0-9]*) (.*)_	\\
		INSERT INTO filenames (inode, size, filename)	\\
		VALUES ('\\1', '\\2', '\\3');	\\
		_
	" | tr '\0' '\n' | $SQLITE

echo -n "Total files: "
$SQLITE "SELECT count(*) FROM filenames;"
