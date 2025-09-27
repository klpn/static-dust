#!/usr/bin/env Rscript
library(morr)
capat <- c("ht", "othhdnoht", "ihdnoami", "ami", "othath", "othcirc",
           "strnovd", "vd", "neurdegnovd", "diab", "chresp", "covid",
           "infnocov", "othdis", "illdef", "ext", "tum")
capatplot(1, "SE110", capat)
ggsave("../../images/cpall_SE110a1.svg", width=9, height=9)
capatplot(1, "SE121", capat)
ggsave("../../images/cpall_SE121a1.svg", width=9, height=9)
capatplot(1, "SE214", capat)
ggsave("../../images/cpall_SE214a1.svg", width=9, height=9)
capatplot(1, "SE231", capat)
ggsave("../../images/cpall_SE231a1.svg", width=9, height=9)
