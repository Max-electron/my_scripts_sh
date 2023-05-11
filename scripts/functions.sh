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