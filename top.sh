#!/bin/bash

rm -rf /home/hadoop/*.tar
rm -rf /database/backup_hdfs/*
LAST="`sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -ls /postgres | awk '{print $8}'`"
DATE="`date +%H%M%S`_`date +%m%d%Y`"
sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -rm -R ${LAST}



sudo -u postgres /usr/pgsql-14/bin/pg_basebackup -p 5432 --checkpoint=fast --format=tar --wal-method=fetch --verbose -D /database/backup_hd$
mv /database/backup_hdfs/base.tar /home/hadoop/
chmod 777 /home/hadoop/base.tar
sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -mkdir -p /postgres/${DATE}
sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -put /home/hadoop/base.tar /postgres/${DATE}/