#!/bin/bash

# General testrun flow:
# Start dram log --> start unilog --> start app --> stop dram log --> stop unilog

#Start Test
echo "Starting ${TESTPLAN_NAME}"

# Start Setup here
${MAIN_DIR}/setup.sh

#myIters="${1:-1}";         
#APP_DIR="/home/pampdhar/scripts/apps"
i=1
while [ ${i} -le ${ITER} ]
do
  nowdate=`date +"%m%d%Y_%H%M%S"`
  printf "\n!!!!!!!!!!!!!!!!!!! ITERATION # ${i}, started at $nowdate !!!!!!!!!!!!!!!!!!!\n"

  # Start Dram logging
  if [ "${DRAMLOG}" = "True" ]; then
    python3 ${MAIN_DIR}/mi300x_dramlog_start.py
  fi

  # Start Unilogging if set to true
  # cd "/home/amd/tools/agt_internal"
  if [ "${UNILOG}" = "True" ]; then
    # Check for optional pre-fix option provided by user
    if [ -z "${LOG_PREFIX}" ]; then
    # No prefix option selected/empty prefix
      export UNILOG_OUT="${CURR_RES_DIR}/${APP_NAME}_$(date +"%Y-%m-%d-%H-%M-%S")_iter_${i}-unilog.csv"
    else
      export UNILOG_OUT="${CURR_RES_DIR}/${LOG_PREFIX}_${APP_NAME}_$(date +"%Y-%m-%d-%H-%M-%S")_iter_${i}-unilog.csv"
    fi  
    export UNILOG_FILE=$(basename "${UNILOG_OUT}")
    sudo -E ${MAIN_DIR}/start_unilogging.sh 2>/dev/null
    sleep 0.5
  fi

  # Starting the app run here
  if [ "${DRYRUN}" = "False" ]; then
    ${MAIN_DIR}/app_run.sh
  fi
  
  # Stop Dram logging
  if [ "${DRAMLOG}" = "True" ]; then
    # Check for optional pre-fix option provided by user
    if [ -z "${LOG_PREFIX}" ]; then
    # No prefix option selected/empty prefix
      export DRAM_OUT="${CURR_RES_DIR}/${APP_NAME}_$(date +"%Y-%m-%d-%H-%M-%S")_iter_${i}-dramlog.csv"
    else
      export DRAM_OUT="${CURR_RES_DIR}/${LOG_PREFIX}_${APP_NAME}_$(date +"%Y-%m-%d-%H-%M-%S")_iter_${i}-dramlog.csv"
    fi  
    python3 ${MAIN_DIR}/mi300x_dramlog_stop.py ${DRAM_OUT}
  fi

  # Stop Unilogging
  if [ "${UNILOG}" = "True" ]; then
    sleep 0.1
    sudo ${MAIN_DIR}/stop_unilogging.sh
  fi

  (( i = i + 1 ))
done

# Start Teardown here
${MAIN_DIR}/teardown.sh



