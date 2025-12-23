#!/usr/bin/env Rscript
library(dplyr)
library(ggplot2)
viw_se_nonsent <- read.delim("data/VIW_FNT_SWE_ns.tsv")
yrlab <- function(x) sprintf("%d/%d", x, (x+1)%%1000)
yrs <- seq(2021,2025)

viw_se_nonsent |>
    filter(as.Date(ISO_WEEKSTARTDATE)>=as.Date("2021-10-04") & (ISO_WEEK<20 | ISO_WEEK>=40)) |>
    mutate(fluweek = if_else(ISO_WEEK>=40, ISO_WEEK-52, ISO_WEEK),
           fluyear = if_else(ISO_WEEK>=40, ISO_YEAR, ISO_YEAR-1)) |>
    ggplot(aes(x=fluweek, y=INF_A, col=factor(fluyear, labels=yrlab(yrs)))) +
    geom_point() + geom_line() + scale_x_continuous(labels=c(42,52,10,20)) +
    scale_y_continuous(transform="log2") +
    labs(col="season", x="week", y="cases", title="Influenza A non-sentinel cases Sweden")
ggsave("../../images/infl_a_se_2021-2025.svg",  width=9, height=9)
