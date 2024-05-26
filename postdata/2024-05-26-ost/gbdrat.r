library(dplyr)
library(ggplot2)
iso_gbd <- inner_join(read.delim("data/gbd17_iso3166_ctries_regs_superregs.tsv",
                                 na.strings = ""),
                      read.delim("data/gbd_superregs_se.tsv"))
le <- read.delim("data/life-expectation-at-birth-by-sex.tsv")
ihme21 <- read.delim("data/ihme21_cvd_tum.tsv")
ihme21_iso_gbd <- inner_join(ihme21, iso_gbd)
ihme21_iso_gbd_le <- inner_join(ihme21_iso_gbd, le)
sexlabs <- c("män", "kvinnor")
calabs <- c("410" = "tumörer", "491" = "cirkulationsorgan")

ratregplot <- function(df, yr, ycol, colgr, ca) {
    ycol <- sym(ycol)
    colgr <- sym(colgr)
    calab <-calabs[[sprintf("%d", ca)]]
    df |> filter(year==yr & cause_id==ca) |> ggplot(aes(x=e0, y=!!ycol, col=!!colgr)) +
        geom_text(aes(label=iso_a2), size=3) +
        labs(x = "e0", y = "kvot",
             title = sprintf("Förväntad livslängd vs döda %s/alla orsaker %d IHME GBD",
                           calab, yr),
             col = "region") +
        scale_color_discrete(labels = ~ stringr::str_wrap(.x, width = 20)) +
        facet_wrap(~factor(sex_id, labels = sexlabs))
}
