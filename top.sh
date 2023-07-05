#!/bin/bash


_bash () {
  echo "$ ${1}"
  ${1};
}

_bash "rm -rf /home/hadoop/*.tar"
_bash "rm -rf /database/backup_hdfs/*"
LAST="`sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -ls /postgres | awk '{print $8}'`"
DATE="`date +%H%M%S`_`date +%m%d%Y`"
_bash "sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -rm -R ${LAST}"



_bash "sudo -u postgres /usr/pgsql-14/bin/pg_basebackup -p 5432 --checkpoint=fast --format=tar --wal-method=fetch --verbose -D /database/backup_hdfs/"
_bash "mv /database/backup_hdfs/base.tar /home/hadoop/"
_bash "chmod 777 /home/hadoop/base.tar"
_bash "sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -mkdir -p /postgres/${DATE}"
_bash "sudo -u hadoop /usr/local/hadoop/bin/hdfs dfs -put /home/hadoop/base.tar /postgres/${DATE}/"