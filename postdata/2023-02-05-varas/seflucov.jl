#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}", raw"\usepackage{unicode-math}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}", raw"\setmathfont{Asana-Math}")
seflu = CSV.File("data/seflu_202140-202304.tsv") |> DataFrame
secov = CSV.File("data/covid_sabohem_202304.tsv") |> DataFrame
p = @pgf Axis({ymode="log",xlabel="vecka", ylabel="antal labbfall", xmajorgrids,
        title="Fall influensa och covid-19 Sverige v. 40/2021–v. 4/2023",xtick="{1,11,20,29,53,65}",
        xticklabels="{40,50,7,16,40,52}", legend_pos = "outer north east"})
@pgf push!(p, PlotInc({"mark=x"}, Table([1:69, seflu[!,:INF_A]])),
        LegendEntry("influensa A"))
@pgf push!(p, PlotInc({"mark=+"}, Table([1:69, seflu[!,:INF_B]])),
        LegendEntry("influensa B"))
@pgf push!(p, PlotInc({"mark=*"}, Table([1:69, secov[40:108,:sabohem]])),
        LegendEntry("covid-19 (äldre)"))
pgfsave("../../images/seflucov_202140-202304.svg", p)
