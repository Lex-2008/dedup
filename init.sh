#!/bin/busybox ash

# Inits database

test -z "$DB" && DB=dedup.db

SQLITE="sqlite3 $DB"

rm -f "$DB"*

# Note that all UNIQUE columns have index on them :)
$SQLITE "CREATE TABLE main(
	inode INTEGER UNIQUE ON CONFLICT IGNORE,
	filename TEXT UNIQUE ON CONFLICT IGNORE,
	size INTEGER);
CREATE TABLE filenames(
	inode INTEGER,
	filename TEXT UNIQUE ON CONFLICT IGNORE,
	size INTEGER); -- not used, but is here for trigger
CREATE TRIGGER add_file INSERT ON filenames
BEGIN
	INSERT INTO main (inode, filename, size)
	VALUES (NEW.inode, NEW.filename, NEW.size);
END;
PRAGMA journal_mode=WAL;"
