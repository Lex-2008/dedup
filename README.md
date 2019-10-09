# dedup
shell script to remove duplicate files

Background
----------

### History

Greatly inspired by [rdfind][], but limited by lack of certain features and
inability to add them due to lack of C++ knowledge, I decided to do what?
Right, to implement my own version, in plain shell, using a database.

[rdfind]: https://rdfind.pauldreik.se/

### Idea

Idea is simple: have a database with a table, with one row for each file, and
columns for each property (like size, first and last bytes, checksum, etc).
Different scriptlets will add such columns, and an SQL query will delete unique
rows. After that, each group of duplicate rows should be hardlinked to each
other.

To properly work with already hardlinked files (they have same inodes), we have
two tables: "main" one with one file per inode (this can be trivially
implemented by adding a UNIQUE constraint to the 'inode' column), and another
one with inode-to-all-filenames mapping (actually, with list of all files).

Usage
-----

### Requirements

* shell (currently, busybox)
* sqlite3
* sed, find

### Sample scripts

You can find sample script is in [sample.sh][]. Run it, passing as arguments
list of directories to scan for duplicates. But you probably should look at it
first and maybe comment out last lines and check the database to see what is
going to happen.

[sample.sh]: sample.sh
