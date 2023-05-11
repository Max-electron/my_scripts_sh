#!/bin/sh
WAL=`ls /database/archive/`
for i in $WAL
do
cp /database/archive/${i} $OAPP_MOUNT_DIR/basebackup/
if [ $? == 0 ]; then
        rm -rf /database/archive/$i
        echo "Continued processing with the returned value $?."
else
    	echo "Exited processing with the returned value $?."
        exit $?
fi
done