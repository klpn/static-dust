#!/usr/bin/env Rscript
source("inflplot.r")
seasonlab <- "säsong (juli år X till juni år X+1, 2023 preliminärt till december)"
pop085 <- popframe("data/se_pop5_1998-2023.tsv")
infl085_sum_fy <- inflframe("data/infl_se_par_085.tsv", "J(09|1[01])") |> inflfdgrp(TRUE)
cov085_sum_fy <- inflframe("data/cov_se_par_085.tsv", "U0[7-9]") |> inflfdgrp(TRUE)
infl085_sum_fy_pop <- inflfnorm(infl085_sum_fy, pop085, c("Sex","sage","sdate"))
cov085_sum_fy_pop <- inflfnorm(cov085_sum_fy, pop085, c("Sex","sage","sdate"))
cov085_sum_fy_pop |> inflplot("2018-02-01", "covid-19", seasonlab, "incidens")
ggsave("../../images/covpop.svg")
infl085_sum_fy_pop |> inflplot("1996-02-01", "influensa", seasonlab, "incidens")
ggsave("../../images/inflpop.svg")
inflfnorm(cov085_sum_fy_pop, inflfmgrp(infl085_sum_fy_pop, max), c("Sex", "sage")) |>
    inflplot("2018-01-01", "covid-19", seasonlab, "incidens/max(incidens(influensa, 1998–2023)")
ggsave("../../images/covnorm.svg")
