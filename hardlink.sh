#!/bin/busybox ash

# Fills database with files

test -z "$DB"  && DB=dedup.db

SQLITE="sqlite3 $DB"

sql="SELECT group_concat(filename,'|') FROM main GROUP BY checksum;"

cmd="	while test \$# -ge 1; do
		files=\"\$(echo \"\$1\" | tr '|' '\\n' | sort)\"
		# TODO: better sort?
		export firstfile=\"\$(echo \"\$files\" | head -n1)\"
		cmd2='rm -f \"\$1\"; ln \"\$firstfile\" \"\$1\"'
		echo \"\$files\" | tail -n+2 | tr '\\n' '\\0' | xargs -n1 -0 sh -c \"\$cmd2\" y
		shift
	done
	"

$SQLITE "$sql" | tr '\n' '\0' | xargs -0 sh -c "$cmd" x
