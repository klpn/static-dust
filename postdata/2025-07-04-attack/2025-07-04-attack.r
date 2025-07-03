#!/usr/bin/env Rscript
library(morr)
capat <- c("ht", "othhdnoht", "ihdnoami", "ami", "othath", "othcirc",
           "strnovd", "vd", "neurdegnovd", "diab", "chresp", "inf",
           "othdis", "illdef", "ext", "tum")
capatplot(1, 2450, capat)
ggsave("../../images/cpall2450a1.svg")
capatplot(1, 4290, capat)
ggsave("../../images/cpall4290a1.svg")
capatplot(1, 4188, capat)
ggsave("../../images/cpall4188a1.svg")
