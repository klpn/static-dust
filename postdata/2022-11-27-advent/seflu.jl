#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}", raw"\usepackage{unicode-math}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}", raw"\setmathfont{Asana-Math}")
seflu = CSV.File("data/seflu_202140-202246.tsv") |> DataFrame
p = @pgf Axis({ymode="log",xlabel="vecka", ylabel="antal labbfall", xmajorgrids,
        title="Fall influensa A Sverige v. 40/2021–v.46/2022",xtick="{1,11,20,29,53}",
        xticklabels="{40,50,7,16,40}"})
@pgf push!(p, PlotInc({"mark=x", "color=blue"}, Table([1:59, seflu[!,:INF_A]])))
pgfsave("../../images/seflu_202140-202246.svg", p)
