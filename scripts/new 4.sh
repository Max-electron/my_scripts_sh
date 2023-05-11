#!/bin/sh
WAL=`ls /database/archive/`
tar -cvf $OAPP_MOUNT_DIR/basebackup/wal.tar /database/archive/$WAL
if [ $? == 0 ]; then
	rm -rf /database/archive/$WAL
	echo "WAL backup was successful and the returned value $?."
else
	echo "WAL backup failed and the returned value $?."
    exit $?
fi
	