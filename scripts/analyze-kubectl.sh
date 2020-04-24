#!/bin/bash

#-------------------------------------------------------------------------------------------------------------------------------
# Analyzes the output of "kubectl --v=10 get xxx" commands. 
#
# Usage: ./analyze-kubectl.sh <file-1> [file-2] [file-n]
#
# --- Sample output of a badly slow cluster:
#$ ./analyze-kubectl.sh file-1.txt file-2.txt
#FILE                   CACHE_READS  NETWORK_REQ  SUCCESS_REQ  NOT_CACHED_REQ  REQ_TOTAL_TIME_(ms)  TOTAL_EXEC_TIME_(s)
#file-1.txt              6764         635          635          537            1620                 88
#file-2.txt              6764         635          635          537            1478                 51
#
#Duplicate requests
#FILE        URL                                                REQUESTS
#file-1.txt  /apis/custom.metrics.k8s.io/v1beta1?timeout=32s    179
#file-2.txt  /apis/custom.metrics.k8s.io/v1beta1?timeout=32s    179
#
# --- Sample output of a healthy cluster:
#$ ./analyze-kubectl.sh healthy
#FILE     CACHE_READS  NETWORK_REQ  SUCCESS_REQ  NOT_CACHED_REQ  REQ_TOTAL_TIME_(ms)  TOTAL_EXEC_TIME_(s)
#healthy   108          1            1            0              518                  1
#
#Duplicate requests
#FILE  URL  REQUESTS
#-------------------------------------------------------------------------------------------------------------------------------

OUT='FILE;CACHE_READS;NETWORK_REQ;SUCCESS_REQ;NOT_CACHED_REQ;REQ_TOTAL_TIME_(ms);TOTAL_EXEC_TIME_(s)\n'
DUPLICATES='FILE;URL;REQUESTS\n'

for l in $@
do
    CACHE_READS=$(cat $l | grep -e "returning cached discovery info from" | wc -l)
    CACHE_WRITES_SKIPPED=$(grep -e "skipped caching discovery info" -e "failed to write cache to" $l | wc -l)

    NETWORK_REQUESTS=$(cat $l | grep -e "GET https://" | wc -l)
    SUCCESSFUL_REQUESTS=$(cat $l | grep -e "GET https.*200 OK" | wc -l)

    REQUESTS_TOTAL_TIME=0
    for t in $(cat $l | grep -e "GET https://" | awk '{print $10}')
    do
        REQUESTS_TOTAL_TIME=$((REQUESTS_TOTAL_TIME + t))
    done

    IFS=$'\n'
    for line in $(cat $l | grep -e "GET https://" | awk '{print $6}' | sed 's|https://\([^/]\)*||g' | sort | uniq -c | sort | grep -v "1 ")
    do
        URL=$(echo $line | awk '{print $2}')
        COUNT=$(echo $line | awk '{print $1}')
        DUPLICATES+="$l;$URL;$COUNT\n"
    done
    unset IFS

    START_TIME=$(cat $l | head -1 | awk '{print $2}' | cut -c 1-8)
    END_TIME=$(cat $l | grep "I" | tail -1 | awk '{print $2}' | cut -c 1-8)
    START_TIME=$(date -jf "%H:%M:%S" $START_TIME "+%s") 
    END_TIME=$(date -jf "%H:%M:%S" $END_TIME "+%s") 
    TOTAL=$((END_TIME - START_TIME))

    OUT+="$l;$CACHE_READS;$NETWORK_REQUESTS;$SUCCESSFUL_REQUESTS;$CACHE_WRITES_SKIPPED;$REQUESTS_TOTAL_TIME;$TOTAL\n"
done

echo -ne $OUT | column -t -s ';'
echo -ne "\n\n"
echo "Duplicate requests"
echo -ne $DUPLICATES | column -t -s ';'
