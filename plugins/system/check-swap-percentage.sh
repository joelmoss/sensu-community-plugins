#!/bin/bash
#
# Checks SWAP usage as a % of the total swap
#
# Date: 05/12/13
# Author: Nick Barrett - EDITED
# License: MIT
#
# Usage: check-swap-percentage.sh -w warn_percent -c critical_percent
# Uses free (Linux-only) & bc

# input options
while getopts ':w:c:' OPT; do
  case $OPT in
    w)  WARN=$OPTARG;;
    c)  CRIT=$OPTARG;;
  esac
done

WARN=${WARN:=100}
CRIT=${CRIT:=100}


# get swap details
USED=`free -m | grep 'Swap:' | awk '{ print $3 }'`
TOTAL=`free -m | grep 'Swap:' | awk '{ print $2 }'`
PERCENT=`echo "scale=3;$USED/$TOTAL*100" | bc -l`
PERCENT=${PERCENT%.*}

OUTPUT="Swap usage: $PERCENT%, $USED/$TOTAL"

if (( $PERCENT >= $CRIT )); then
  echo "SWAP CRITICAL - $OUTPUT"
  exit 2
elif (( $PERCENT >= $WARN )); then
  echo "SWAP WARNING - $OUTPUT"
  exit 1
else
  echo "SWAP OK - $OUTPUT"
  exit 0
fi
