#!/usr/bin/env julia
using CSV, DataFrames, PGFPlotsX
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\usepackage{fontspec}")
push!(PGFPlotsX.CUSTOM_PREAMBLE, raw"\setmainfont{Asana-Math}")
seflu1617 = CSV.File("data/Rpt_LabSurveillanceDataAnyWeekByCtry_Chart_se_201640-201720.tsv") |> DataFrame
seflu21 = CSV.File("data/Rpt_LabSurveillanceDataAnyWeekByCtry_Chart_se_202120-202149.tsv") |> DataFrame
seflu1617[!,:AH3_NS] = seflu1617[!,:AH3] + seflu1617[!,:ANOTSUBTYPED]
seflu21[!,:AH3_NS] = seflu21[!,:AH3] + seflu21[!,:ANOTSUBTYPED]
p = @pgf Axis({ymode="log",xlabel="vecka", ylabel="antal labbfall", xmajorgrids,
    title="Fall influensa A(H3N2) och A ej subtypad Sverige",
    xtick="{1,10,13,33}",xticklabels="{40,49,52,20}"})
@pgf push!(p, PlotInc({"mark=x", "color=blue"}, Table([1:33,seflu1617[!,:AH3_NS]])), LegendEntry("2016/17"))
@pgf push!(p, PlotInc({"mark=*", "color=red"}, Table([1:10,seflu21[21:30,:AH3_NS]])), LegendEntry("2021/22"))
inflpl = "se_flu_1617_4020_21_4049"
inflplpath = "../../images/$(inflpl).svg"
print(*("![Labbfall influensa A(H3N2) och A ej subtypad Sverige 2016/17 och 2021/22.]",
    "($(inflplpath)){#fig:$(inflpl) width=100%}\n\n"))
pgfsave(inflplpath, p)
