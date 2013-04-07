#!/bin/bash

# Database credentials
USER=""
PASS=""
HOST=""
PORT="3306"

#* MySQL binaries *#
MYSQL=`which mysql`;
MYSQLDUMP=`which mysqldump`;
GZIP=`which gzip`;

# DO NOT BACKUP these databases
IGNOREDBS="information_schema mysql test"

# The directory to store the backup. Do not add a trailing slash.
BACKUPDIR="/var/backups/mysql"
DATE=$(date +"%d-%b-%Y")

# Set default file permissions
umask 177

# Check is backup dir exists.
if [ ! -d $BACKUPDIR ]; then
    echo "Error: The directory $BACKUPDIR does not exist"
    exit 1
fi

# get all database listing
DBS="$($MYSQL -u $USER -p$PASS -h $HOST -P $PORT -Bse 'show databases')"

for db in $DBS:
    do
        DUMP="yes";
        if [ "$IGNOREDB" != "" ]; then
            for i in $IGNOREDB # Store all value of $IGNOREDB ON i
                do
                    if [ "$db" == "$i" ]; then
                        DUMP="NO";
                        #echo "$i database is being ignored!";
                    fi
                done
        fi

        if [ "$DUMP" == "yes" ]; then
                FILE="$BACKUPDIR/$DATE-$db.gz";
                echo "BACKING UP $db";
                $MYSQLDUMP --max_allowed_packet=500M --routing --triggers --add-drop-database --opt --lock-all-tables -u $USER -p$PASS -h $HOST -P $PORT $db > $FILE
        fi
done

# Delete files older than 30 days
find $BACKUPDIR/* -mtime +30 -exec rm {} \;
