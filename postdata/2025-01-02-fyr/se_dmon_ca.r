library(ggplot2)
library(dplyr)

se_dmon_ca <- read.delim("data/se_dmon_ca_6924.tsv")

sexlabs <- c("kvinnor", "män")
calabs <- c("akut hjärtinfarkt", "annan ischemisk hjärtsjukdom",
            "akuta luftvägsinfektioner och influensa", "lunginflammation",
            "ischemisk hjärtsjukdom", "influensa och lunginflammation")
names(calabs) <- c("F23", "F24", "F27", "F28", "I20–I25", "J09–J18")

cayrsplot <- function(c, a) {
    pltitle <- sprintf("Döda per månad %s Sverige ålder %d–ω", calabs[c], a)
    se_dmon_ca |> filter(ca==c & age==a) |>
        ggplot(aes(x=month, y=deaths, col=factor(sex, levels=2:1, labels=sexlabs))) +
        geom_point() + geom_line() + scale_x_continuous(breaks=1:12) + scale_y_log10() +
        labs(x="månad", y="döda", col="kön", title=pltitle) + facet_wrap(~year)
}
