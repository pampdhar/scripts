#!/bin/bash

# Must be run priveleged: AGT and prject pi require it

# Required Environment variables
# AGT_INTERNAL_PATH: path to agt internal
# AGT_INTERNAL_DEVICES: comma separated list of device indices

# unilog
# Use terminate.txt file to stop unilogging later.
if [ -f terminate.txt ]; then
  rm terminate.txt
fi

if pgrep -x "agt_internal" > /dev/null
then
  >&2 echo "[ERROR] AGT is already running when running start_unilogging.sh."
  exit -1
fi

if [ ! -f "$AGT_INTERNAL_PATH" ]; then
  >&2 echo "[ERROR] AGT_INTERNAL_PATH is unset or not a valid path to agt_internal."
  exit -1
fi

# nohup suppress AGT ctrl-c dialog.
nohup ${AGT_INTERNAL_PATH} \
  -i=${AGT_INTERNAL_DEVICES} \
  -unilog=${UNILOG_COMP} \
  -unilogallgroups \
  -unilogperiod=${UNILOG_SR} \
  -unilognoesckey \
  -unilogstopcheck \
  -unilogoutput=${UNILOG_OUT} &

echo "[INFO] AGT internal unilogging started."
