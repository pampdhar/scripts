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

  # Start project pi logging
  cd "/root/.cache/orc_ppa_fmt/Project_Pi_Repository/"
  /root/.cache/orc_ppa_fmt/Project_Pi_Repository/start_linux
  
  # Start Dram logging
  if [ "${DRAMLOG}" = "True" ]; then
    python3 ${MAIN_DIR}/mi300x_dramlog_start.py
  fi

  # Start Unilogging if set to true
  cd "${AGT_DIR}"
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

  # Stop project pi
  cd "/root/.cache/orc_ppa_fmt/Project_Pi_Repository/"
  /root/.cache/orc_ppa_fmt/Project_Pi_Repository/stop_linux
  sleep 0.5
  /root/.cache/orc_ppa_fmt/Project_Pi_Repository/interpret_linux
  sleep 0.5
  /root/.cache/orc_ppa_fmt/Project_Pi_Repository/reset_linux
  sleep 0.5

  (( i = i + 1 ))
done

# Start Teardown here
#${MAIN_DIR}/teardown.sh



