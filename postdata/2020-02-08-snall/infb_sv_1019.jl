#!/usr/bin/env julia
using CSV, DataFrames, PyCall, PyPlot
PyDict(matplotlib."rcParams")["axes.formatter.use_locale"] = true
infb_sv_1019 = CSV.File("data/infb_sv_1019.csv") |> DataFrame
infb_sv_1019[:b_prop] = infb_sv_1019[:b]./infb_sv_1019[:samples]
scatter(infb_sv_1019[:b_prop_vic],
    infb_sv_1019[:median_age_b], s = infb_sv_1019[:b_prop]*5000,
    color="lightblue")
grid(1)
for (i, season) in enumerate(infb_sv_1019[:season])
    annotate(season, (infb_sv_1019[:b_prop_vic][i],
        infb_sv_1019[:median_age_b][i]))
end
title("Laboratorierapporterad influensa B Sverige 2010–19")
xlabel("Andel B Victoralinjen")
ylabel("Medianålder fall")
savefig("../../images/infb_sv_1019.svg")
