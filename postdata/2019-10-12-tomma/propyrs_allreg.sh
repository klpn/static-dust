#!/bin/sh
find ./data -type f -name '*.csv' -print0 |\
	xargs -0 -n1 -P4 grep -E ";(${3#^}|${4#^});$1;$2" |\
	awk -v sex=$1 -v age=$2 -v ca1="$3" -v ca2="$4" -f propyrs_allreg.awk | sort