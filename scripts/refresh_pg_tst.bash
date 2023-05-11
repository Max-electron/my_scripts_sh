###############################################################
# refresh_pg_tst.sh                                                                                                                             
###############################################################
#!/bin/bash



_check_status() {
  echo "------------------------------------------"
  echo "Statistics:"
  echo "================="
  echo "  start: ${START_TIME}"
  echo "  done : `date  +%T` `date +%m-%d-%Y`"
  if [ ${RETURN_CODE} -eq 0 ]; then
    echo "  Status: STAGE - ${1}: completed successfully" 
    exit 0
  else
    echo "  Status: STAGE - ${1}: failed with error code: ${RETURN_CODE}"
    exit 1
  fi
}

_show_message() {
  local START_TIME="`date  +%T` `date +%m-%d-%Y`"
  echo ""
  echo $START_TIME
  echo "#################################################"
  echo -e "#${1}\n"
}

_show_error() {
  echo -e "\n------------------------------------------"
  echo " `date  +%T` `date +%m-%d-%Y`: ERROR: ${1} -- ${2}"
  RETURN_CODE=$1
  exit 1
}

_bash () {
  echo "$ ${1}"
  ${1};
  [ $? -ne 0 ] && _show_error $BASH_ERR_CODE "bash command failed"
}

# Main:

trap '_check_status $RD_STAGE' EXIT


START_TIME="`date  +%T` `date +%m-%d-%Y`"
RETURN_CODE=0
PGDATA="/database/clusterstorage/data"
BASH_ERR_CODE=222

_show_message "Остановка postgresql-14"
_bash "sudo systemctl stop postgresql-14"

_show_message "Очистка директории PGDATA"
_bash "sudo rm -rf ${PGDATA}"

_show_message "Закачка данных с ПРОД СЕРВЕРА"
_bash "time /usr/pgsql-14/bin/pg_basebackup -h 10.9.39.22 -p 5432 --checkpoint=fast --wal-method=fetch --pgdata=${PGDATA}"

[ -e ${PGDATA}/standby.signal ] && _bash "rm ${PGDATA}/standby.signal"
if [ $? -eq 0 ]
then
    echo "File(s) standby.signal succesfully removed!"
	
[ -e ${PGDATA}/backup* ] && _bash "rm ${PGDATA}/backup*"
if [ $? -eq 0 ]
then
    echo "File(s) backup* succesfully removed!"
	
_show_message "Запуск postgresql-14"
_bash "sudo systemctl start postgresql-14"

#_show_message "Проверка статуса"
#_bash "sudo systemctl status postgresql-14 2>&1"



