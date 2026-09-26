#!/usr/bin/env Rscript
library(morr)

ctry_awsyplot("4290", "athhd", "all", 1997, 2024, aws=aw_o, alabs=agelabs_w_o)
ggsave("../../images/athhdall4290asy.svg", width=9, height=9)
