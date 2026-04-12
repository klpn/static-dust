#!/usr/bin/env Rscript
library(morr)

circall <- ctry_caf("all", "circ", "all")
circall |> thrctries(0.5, 200, 1, 1) |> arrange(yr_max, ctry) |>
    write.table("data/prop_x_m.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
circall |> thrctries(0.5, 200, 2, 1) |> arrange(yr_max, ctry) |>
    write.table("data/prop_x_f.tsv", sep = "\t", quote = FALSE, row.names = FALSE)
