#!/bin/sh
find . -type f -name '*.csv' -print0 | xargs -0 -n1 -P4 awk -v reg=$1 -v sex=$2 -v age=$3 -v ca1="$4" -v ca2="$5" -f propyrs.awk | sort