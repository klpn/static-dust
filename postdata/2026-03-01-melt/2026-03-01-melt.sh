#!/bin/sh
iconv -f windows-1252 -t utf-8 data/dinflAldsasong_20260301-194643.txt |
    awk -f inflinc.awk > data/inflinc.tsv
Rscript 2026-03-01-melt.r
