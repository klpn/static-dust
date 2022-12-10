#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}", raw"\usepackage{unicode-math}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}", raw"\setmathfont{Asana-Math}")
seflu = CSV.File("data/seflu_202140-202248.tsv") |> DataFrame
secov = CSV.File("data/FHM_latest_Veckodata_Riket.tsv") |> DataFrame
p = @pgf Axis({ymode="log",xlabel="vecka", ylabel="antal labbfall", xmajorgrids,
        title="Fall influensa A och covid-19 Sverige v. 40/2021–v. 48/2022",xtick="{1,11,20,29,53}",
        xticklabels="{40,50,7,16,40}"})
@pgf push!(p, PlotInc({"mark=x", "color=blue"}, Table([1:61, seflu[!,:INF_A]])),
        LegendEntry("influensa A"))
@pgf push!(p, PlotInc({"mark=+", "color=red"}, Table([1:61, secov[88:148,:Antal_fall_vecka]])),
        LegendEntry("covid-19"))
pgfsave("../../images/seflucov_202140-202248.svg", p)
