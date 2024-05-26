#!/usr/bin/env Rscript
source("gbdrat.r")
ihme21_iso_gbd_le |> ratregplot(2019, "val", "superreg_name_se", 410)
ggsave("../../images/ihme21_e0_tum_2019.svg", width=10, height=6)
ihme21_iso_gbd_le |> ratregplot(2019, "val", "superreg_name_se", 491)
ggsave("../../images/ihme21_e0_circ_2019.svg", width=10, height=6)
