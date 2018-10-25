#!/bin/sh
iconv -f iso_8859-1 -t utf-8 data/mfsv17.scb | ./sepop.awk > data/mfsv17.csv
./sedor.awk < data/2018-10-17-4A.csv > data/2018-10-17-4Amod.csv
