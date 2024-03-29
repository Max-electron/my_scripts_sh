#!/bin/bash

###########################################################################
#                                                                         #
#                                FUNCTIONS                                #
#                                                                         #
###########################################################################

_show_message() {
  local START_TIME="`date  +%T` `date +%m-%d-%Y`"
  echo ""
  echo $START_TIME
  echo "#################################################"
  echo -e "#${1}\n"
}

_bash() {
  echo "$ ${1}"
  ${1};
  [ $? -ne 0 ] && _show_error $BASH_ERR_CODE "bash command failed"
}

###########################################################################
#                                                                         #
#                                VARIABLES                                #
#                                                                         #
###########################################################################

POSTGRES_VERSION=$1
PGDATA=/database/clusterstorage/data
WAL_ARCHIVE=/database/archive
BACKUP=/database/data

###########################################################################
#                                                                         #
#                                SCRIPT                                   #
#                                                                         #
###########################################################################


_show_message "останавливаем кластер postgres"
_bash "systemctl stop postgresql-${POSTGRES_VERSION}"

_show_message "удаляем старый бэкап"
_bash "rm -rf ${BACKUP}/*"

_show_message "удаляем старые архивные WAL"
_bash "rm -rf ${WAL_ARCHIVE}/*"

_show_message "удаляем старый кластер postgres"
_bash "rm -rf ${PGDATA}/*"

_show_message "инициализация кластера БД PostgreSQL"
_bash "sudo -u postgres /usr/lib/postgresql/${POSTGRES_VERSION}/bin/initdb -k -D /database/clusterstorage/data/ --wal-segsize=64"

_show_message "настраиваем архивирование WAL"
sed -i "s/#archive_mode = off/archive_mode = on/g" "${PGDATA}/postgresql.conf"
#sed -i "s/#archive_command = ''/archive_command = 'test ! -f /database/archive/`%f` && cp `%p` /database/archive/`%f`'/g" "${PGDATA}/postgresql.conf"

_show_message "запускаем кластер postgres"
_bash "systemctl start postgresql-${POSTGRES_VERSION}"

sudo -u postgres psql -c "alter system set archive_command = 'test ! -f /database/archive/%f && cp %p /database/archive/%f';"

_show_message "рестарт кластера postgres"
_bash "systemctl restart postgresql-${POSTGRES_VERSION}"

sudo -u postgres psql -c "show archive_mode;"
sudo -u postgres psql -c "show archive_command;"

_show_message "создаем нагрузку накатом скрипта"
sudo -u postgres psql -f /var/lib/postgresql/demo-small.sql

_show_message "проверяем архивные WAL"
_bash "ls -lh /database/archive"

_show_message "выполняем FULL BACKUP"
sudo -u postgres /usr/lib/postgresql/${POSTGRES_VERSION}/bin/pg_basebackup -p 5432 --checkpoint=fast --wal-method=fetch --verbose -D /database/data/

_show_message "проверяем бэкап"
_bash "ls -lh /database/data/"

_show_message "создаем таблицу test"
sudo -u postgres psql -c "CREATE TABLE test
(
    Id SERIAL PRIMARY KEY,
    ProductName VARCHAR(30) NOT NULL,
    Manufacturer VARCHAR(20) NOT NULL,
    ProductCount INTEGER DEFAULT 0,
    Price NUMERIC
);"

_show_message "вставляем данные в таблицу test"
sudo -u postgres psql -c "INSERT INTO test VALUES (1, 'Galaxy S9', 'Samsung', 4, 63000);"
sudo -u postgres psql -c "INSERT INTO test VALUES (2, 'Galaxy S10', 'Samsung', 8, 70000);"
sudo -u postgres psql -c "INSERT INTO test VALUES (3, 'Galaxy S56', 'Samsung2', 5, 7000124);"
sudo -u postgres psql -c "INSERT INTO test VALUES (4, 'Galaxy S35', 'Samsung5', 3, 7412549);"
sudo -u postgres psql -c "INSERT INTO test VALUES (5, 'Galaxy S24', 'Samsung5', 2, 12546);"

_show_message "смотрим таблицу test"
sudo -u postgres psql -c "select * from test;"

sudo -u postgres psql -c "select current_timestamp" | awk 'NR == 3{print $1 " " $2}' > /var/lib/postgresql/file
cp /var/lib/postgresql/file /root/
TIMESTAMP=`cat /root/file`
echo $TIMESTAMP
export TIMESTAMP

sudo -u postgres psql -c "drop database demo;"

_show_message "создаем нагрузку накатом скрипта"
sudo -u postgres psql -f /var/lib/postgresql/demo-small.sql

_show_message "проверяем архивные WAL"
_bash "ls -lh /database/archive"

_show_message "останавливаем старый кластер"
_bash "systemctl stop postgresql-${POSTGRES_VERSION}"

_show_message "удаляем старый кластер"
_bash "rm -rf ${PGDATA}/*"

_show_message "переносим бэкап"
_bash "mv /database/data/* /database/clusterstorage/data/"

sed -i "s/#recovery_target_time = ''/recovery_target_time = '$TIMESTAMP'/g" "${PGDATA}/postgresql.conf"
if [ $? -eq 0 ]; then
    echo "recovery_target_time succesfully update!"
else
    echo "recovery_target_time update FAILED!"
fi

sed -i "s/#recovery_target_action = 'pause'/recovery_target_action = 'promote'/g" "${PGDATA}/postgresql.conf"
if [ $? -eq 0 ]; then
    echo "recovery_target_action succesfully update!"
else
    echo "recovery_target_action update FAILED!"
fi

sed -i "s|#restore_command = ''|restore_command = 'cp /database/archive/%f %p'|g" "${PGDATA}/postgresql.conf"
if [ $? -eq 0 ]; then
    echo "restore_command succesfully update!"
else
    echo "restore_command update FAILED!"
fi

sed -i "s/#logging_collector = off/logging_collector = on/g" "${PGDATA}/postgresql.conf"
if [ $? -eq 0 ]; then
    echo "logging_collector succesfully update!"
else
    echo "logging_collector update FAILED!"
fi

sudo -u postgres touch /var/lib/postgresql/${POSTGRES_VERSION}/data/recovery.signal

_show_message "старуем pitr"
_bash "systemctl start postgresql-${POSTGRES_VERSION}"

sudo -u postgres psql -c "select * from test;"