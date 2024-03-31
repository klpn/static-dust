library(ggplot2)
library(dplyr)
library(clock)
library(tidyr)
Sys.setlocale("LC_TIME", "sv_SE.UTF-8")

alabs <- c("0–4", "5–9", "10–14", "15–19", "20–24", "25–29", "30–34", "35–39",
            "40–44", "45–49", "50–54", "55–59", "60–64", "65–69", "70–74", "75–79",
            "80–84", "85+")
sexlabs <- c("kvinnor", "män")

popframe <- function(ppath) {
    popf <- read.delim(ppath)
    popf$sdate <- date_build(popf$Year, 1, 1)
    popf$sage <- as.integer(sapply(strsplit(popf$Age, "-"), "[[", 1))
    popf$sage <- sapply(popf$sage, function(x) min(85,x))
    popf |> group_by(Sex,sage,sdate) |> summarise(n=sum(pop))
}

inflframe <- function(ipath, icde) {
    inflf <- read.delim(ipath)
    inflf$sdate <- as.Date(paste(1, inflf$Month, inflf$Year), "%d %B %Y")
    inflf$sage <- as.integer(sapply(strsplit(inflf$Age, "[–+]"), "[[", 1))
    inflf |> pivot_longer(matches(icde), names_to="icd", values_to="n")
}

inflfmgrp <- function(inflf, f) {
    inflf_max <- inflf |> group_by(Sex,sage) |> summarise(n=f(n))
}

inflfdgrp <- function(inflf, fygrp) {
    if (fygrp) inflf$sdate <- date_build(get_year(inflf$sdate-180), 1, 1)
    inflf_sum <- inflf |> group_by(Sex,sage,sdate) |> summarise(n=sum(n))
}

inflfnorm <- function(f1, f2, cols) {
    inflf_norm <- inner_join(f1, f2, by=cols)
    inflf_norm$n <- inflf_norm$n.x / inflf_norm$n.y
    inflf_norm |> select(!c(n.x, n.y))
}

inflplot <- function(inflf, sd, diaglab, xlab, ylab) {
    pltitle = sprintf("Utskrivna  slutenvård huvuddiagnos %s per ålder och kön Sverige", diaglab)
    inflf |> filter(sdate>sd) |>
        ggplot(aes(x=sdate, y=n, col=factor(Sex, labels=sexlabs))) + geom_point() + geom_line() +
        labs(title = pltitle, x=xlab, y=ylab, col = "kön") + scale_y_log10() +
        theme(axis.text.x = element_text(size=8)) +
        facet_wrap(~factor(sage, labels=alabs), ncol=3, scales="free_y")
}
