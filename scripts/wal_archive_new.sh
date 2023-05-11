#!/bin/sh
WAL=`ls /database/archive/`
cd /database/archive
tar -cvf wal.tar /database/archive/$WAL
if [ $? == 0 ]; then
        echo "The archive was created successfully and the returned value $?."
else
    	echo "Archive creation failed and the returned value $?."
        exit $?
fi
cp /database/archive/wal.tar $OAPP_MOUNT_DIR/basebackup 
if [ $? == 0 ]; then
        rm -rf /database/archive/$WAL
        rm /database/archive/wal.tar
        echo "WAL backup was successful and the returned value $?."
else
    	echo "WAL backup failed and the returned value $?."
        exit $?
fi