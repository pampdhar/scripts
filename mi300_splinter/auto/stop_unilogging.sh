#!/bin/bash

# Must be run priveleged: AGT and project pi require it

# Terminate gracefully
touch terminate.txt

agt_timeout=2
# Wait for TIMEOUT seconds for AGT to exit.
# If it doesn't, SIGKILL it.
sleep $agt_timeout
if pgrep -x "agt_internal" > /dev/null
then
    echo "[WARN] agt_internal did not stop gracefully. Killing it!"
    pkill -9 agt_internal
    rm terminate.txt
fi

# Verify unilog exists and is non-zero
if [ ! -f ${UNILOG_FILE} ]; then
    >&2 echo "[ERROR] AGT completed but no unilog file exists!"
    exit -1
fi

echo "[INFO] AGT internal logging stopped."