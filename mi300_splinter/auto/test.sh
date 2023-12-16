#!/bin/bash
# Author: Pamposh Dhar
# Run this top level test file to run the test
# Run command: . test.sh

# User defined variables
# Tier 1
export TESTPLAN_NAME="Integration Test"
export APP_NAME="minihpl"
export ITER=1 # Number of app run iterations
export DRYRUN="False"
export DRAMLOG="True"
export UNILOG="True"
export LOG_PREFIX=""
export UNILOG_SR=50 # Samplisng rate in ms
export UNILOG_COMP="PM,TMON" # Valid Unilog components = PM, TMON, BTC


# Tier 2
export USER="pampdhar"
export HOME_DIR="/home/$USER"
export MAIN_DIR="/home/$USER/scripts/auto"
export APP_DIR="/home/$USER/scripts/apps"
export AGT_DIR="/home/amd/tools/agt_internal"
export RESULTS_DIR="/home/$USER/results"
export CURR_RES_DIR=""
export AGT_INTERNAL_PATH=/home/amd/tools/agt_internal/agt_internal
export AGT_INTERNAL_DEVICES=0,1,2,3,4

###############################################################################
###############################################################################

#Defining the Results directory thats created on each run
res_dir_name="Results_$(date +"%Y-%m-%d-%H-%M-%S")"
sudo mkdir -p ${RESULTS_DIR}/${res_dir_name}
export CURR_RES_DIR="${RESULTS_DIR}/${res_dir_name}"

# Calling the Main run script and creating a run log in the Current Results Folder
source ${MAIN_DIR}/main.sh | tee "${CURR_RES_DIR}/run.log"

echo "Results Folder Created at: ${CURR_RES_DIR}"