#!/usr/bin/env Rscript
library(morr)

hmd <- hmdltfs()
capat <- c("ht", "othhdnoht", "ihdnoami", "ami", "othath", "othcirc",
           "strnovd", "vd", "neurdegnovd", "diab", "chresp", "covid", "infnocov",
           "othdis", "illdef", "ext", "tum")
capatplot(1, 4290, capat)
ggsave("../../images/cpall4290a1c.svg", width=9, height=9)
capatplot(0, 4290, capat, hltf = hmd)
ggsave("../../images/cpall4290a0c_hmd.svg", width=9, height=9)
