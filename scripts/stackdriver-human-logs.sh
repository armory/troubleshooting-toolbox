#!/bin/bash

#----------------------------------------------------------------------------------------------------------------------------------------
# Format stackdriver json logs to a human readable format.
#----------------------------------------------------------------------------------------------------------------------------------------

LOG_FILE=$1

[[ "x$LOG_FILE" = "x" ]] && echo "Usage: $(basename $0) log_file"

cat ${LOG_FILE} | jq -r '.[] | [.timestamp, .jsonPayload.hostname, .jsonPayload.Severity, .jsonPayload.logger, .jsonPayload.message] | @tsv' | awk -v FS="\t" '{printf "[%s] [%-20.20s] [%s] [%-55.55s] %s%s",$1,$2,$3,$4,$5,ORS}'

