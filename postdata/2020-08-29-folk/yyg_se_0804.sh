#!/bin/sh
echo "date,predicted_deaths_mean,predicted_deaths_lower,predicted_deaths_upper"
find ./projections/ -type f -name 'Sweden_ALL.csv' | sort |\
xargs awk -F',' '$1=="2020-08-04" && $7!=""{printf("%s,%s,%s,%s\n", substr(FILENAME,15,10), $7, $8, $9)}'
