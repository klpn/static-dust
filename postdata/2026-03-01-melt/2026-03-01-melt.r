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
ggsave("../../images/infl_a_se_202140-202608.svg",  width=9, height=9)

sexlabs <- c("females", "males")
agelabs <- c("0–4", "5–14", "15–39", "40–64", "65–ω")

inflinc <- read.delim("data/inflinc.tsv")

inflinc |>
    mutate(fluweek = if_else(week>=40, week-52, week)) |>
    ggplot(aes(x=fluweek, y=inc, col=factor(sex, levels=2:1, labels=sexlabs))) +
    geom_point() + geom_line() + scale_x_continuous(breaks=c(-10,-5,0,5), labels=c(42,47,52,5)) +
    scale_y_continuous(transform="log2") +
    labs(col="sex", x="week", y="cases/100\ 000",
         title="Influenza A non-sentinel cases by age and sex Sweden 2025/26") +
    facet_wrap(~factor(age, labels=agelabs))
ggsave("../../images/infl_a_se_incagesex_202540-202608.svg",  width=9, height=9)
