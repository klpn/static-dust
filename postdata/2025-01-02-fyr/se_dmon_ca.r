library(ggplot2)
library(dplyr)

se_dmon_ca <- read.delim("data/se_dmon_ca_6924.tsv")

sexlabs <- list(en = c("females", "males"), sv = c("kvinnor", "män"))

calabs <- list("F23" = c(en = "acute myocardial infarction", sv = "akut hjärtinfarkt"),
             "F24" = c(en = "other ischemic heart disease",
                         sv = "annan ischemisk hjärtsjukdom"),
             "F27" = c(en = "acute respiratory infections and influenza",
                       sv= "akuta luftvägsinfektioner och influensa"),
             "F28" = c(en = "pneumonia", sv = "lunginflammation"),
             "I20–I25" = c(en = "ischemic heart disease",
                           sv = "ischemisk hjärtsjukdom"),
             "J09–J18" = c(en = "influenza and pneumonia",
                           sv = "influensa och lunginflammation"))
pllabs <- list(x = c(en = "month", sv = "månad"), y = c(en = "deaths", sv = "döda"),
               col = c(en = "sex", sv = "kön"),
               title = c(en = "Deaths per month %s Sweden age %d–ω",
                         sv = "Döda per månad %s Sverige ålder %d–ω"))


cayrsplot <- function(c, a, l){
    pltitle <- sprintf(pllabs[["title"]][[l]], calabs[[c]][[l]], a)
    se_dmon_ca |> filter(ca==c & age==a) |>
        ggplot(aes(x=month, y=deaths, col=factor(sex, levels=2:1, labels=sexlabs[[l]]))) +
        geom_point() + geom_line() + scale_x_continuous(breaks=1:12) + scale_y_log10() +
        labs(x=pllabs[["x"]][[l]], y=pllabs[["y"]][[l]],
             col=pllabs[["col"]][[l]], title=pltitle) +
        facet_wrap(~year)
}
